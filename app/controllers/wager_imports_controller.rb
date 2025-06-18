class WagerImportsController < ApplicationController
  before_action :authenticate_user!
  require 'csv'

  def new
    # Show CSV import form
  end

  def create
    unless params[:csv_file]
      redirect_to new_wager_import_path, alert: 'Please select a CSV file.'
      return
    end

    begin
      imported_count = 0
      errors = []

      CSV.foreach(params[:csv_file].path, headers: true, header_converters: :symbol) do |row|
        # Clean up headers (remove spaces, downcase)
        clean_row = {}
        row.to_h.each do |key, value|
          clean_key = key.to_s.strip.downcase.gsub(/\s+/, '_').to_sym
          clean_row[clean_key] = value&.strip
        end

        wager = current_user.wagers.build(
          date: parse_date(clean_row[:date]),
          amount: clean_row[:amount] || clean_row[:amounts],
          odds: clean_row[:odds],
          result: clean_row[:result],
          sportsbook: clean_row[:sportsbook],
          tags: clean_row[:tags]
        )

        if wager.save
          imported_count += 1
        else
          errors << "Row #{$.}: #{wager.errors.full_messages.join(', ')}"
        end
      end

      if errors.empty?
        redirect_to wagers_path, notice: "Successfully imported #{imported_count} wagers."
      else
        redirect_to wagers_path, alert: "Imported #{imported_count} wagers with #{errors.count} errors: #{errors.first(3).join('; ')}"
      end

    rescue CSV::MalformedCSVError => e
      redirect_to new_wager_import_path, alert: "Invalid CSV file: #{e.message}"
    rescue => e
      redirect_to new_wager_import_path, alert: "Import failed: #{e.message}"
    end
  end

  def export
    respond_to do |format|
      format.csv do
        # Apply tag filter if present
        wagers = current_user.wagers.includes(:user)
        wagers = wagers.where("tags ILIKE ?", "%#{params[:tag]}%") if params[:tag].present?
        wagers = wagers.order(:date)

        csv_data = CSV.generate(headers: true) do |csv|
          csv << ['date', 'amount', 'odds', 'result', 'sportsbook', 'tags']
          
          wagers.each do |wager|
            csv << [
              wager.date.strftime('%Y-%m-%d'),
              wager.amount,
              wager.odds,
              wager.result,
              wager.sportsbook,
              wager.tags
            ]
          end
        end

        filename = "wagers_#{Date.current.strftime('%Y%m%d')}"
        filename += "_#{params[:tag]}" if params[:tag].present?
        filename += ".csv"

        send_data csv_data, filename: filename, type: 'text/csv'
      end
    end
  end

  private

  def parse_date(date_string)
    return Date.current if date_string.blank?
    
    # Try different date formats
    date_formats = ['%Y-%m-%d', '%m/%d/%Y', '%d/%m/%Y', '%Y/%m/%d']
    
    date_formats.each do |format|
      begin
        return Date.strptime(date_string, format)
      rescue ArgumentError
        next
      end
    end
    
    # If no format works, try to parse naturally
    Date.parse(date_string) rescue Date.current
  end
end