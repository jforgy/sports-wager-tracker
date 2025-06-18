require 'csv'

class CsvController < ApplicationController
  before_action :authenticate_user!

  def import_form
    # Show CSV import form
  end

  def import
    unless params[:csv_file]
      redirect_to csv_import_form_path, alert: 'Please select a CSV file.'
      return
    end

    begin
      imported_count = 0
      errors = []

      CSV.foreach(params[:csv_file].path, headers: true) do |row|
        # Convert headers to lowercase and handle common variations
        clean_row = {}
        row.to_h.each do |key, value|
          clean_key = key.to_s.strip.downcase.gsub(/\s+/, '_')
          clean_row[clean_key] = value&.strip
        end

        # Handle different column name variations
        date = clean_row['date']
        amount = clean_row['amount'] || clean_row['amounts']
        odds = clean_row['odds']
        result = clean_row['result']
        sportsbook = clean_row['sportsbook']
        tags = clean_row['tags']

        wager = current_user.wagers.build(
          date: parse_date(date),
          amount: amount,
          odds: odds,
          result: result,
          sportsbook: sportsbook,
          tags: tags
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

    rescue => e
      redirect_to csv_import_form_path, alert: "Import failed: #{e.message}"
    end
  end

  def export
    wagers = current_user.wagers.order(:date)

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

    filename = "wagers_export_#{Date.current.strftime('%Y%m%d')}.csv"
    send_data csv_data, filename: filename, type: 'text/csv'
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