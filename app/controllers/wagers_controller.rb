class WagersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wager, only: [:show, :edit, :update, :destroy]
  
  def index
    # Base query
    @wagers = current_user.wagers
    
    # Apply filters
    @wagers = filter_wagers(@wagers)
    
    # Order by date (newest first)
    @wagers = @wagers.order(date: :desc)
    
    # Calculate metrics based on filtered wagers
    @total_wagered = @wagers.sum(:amount)
    @total_profit_loss = @wagers.sum(&:profit_loss)
    @win_percentage = @wagers.count > 0 ? (@wagers.wins.count.to_f / @wagers.count * 100).round(1) : 0
    @roi_percentage = @total_wagered > 0 ? ((@total_profit_loss / @total_wagered) * 100).round(1) : 0
    
    # Get all unique tags and sportsbooks for filter dropdowns
    all_wagers = current_user.wagers
    @all_tags = all_wagers.where.not(tags: [nil, ''])
                         .pluck(:tags)
                         .flat_map { |tag_string| tag_string.split(',').map(&:strip) }
                         .uniq
                         .sort
    
    @all_sportsbooks = all_wagers.where.not(sportsbook: [nil, ''])
                                 .distinct
                                 .pluck(:sportsbook)
                                 .sort
    
    # Store current filter values for the form
    @current_tag = params[:tag]
    @current_sportsbook = params[:sportsbook]
    @current_start_date = params[:start_date]
    @current_end_date = params[:end_date]
  end
  
  def show
  end
  
  def new
    @wager = current_user.wagers.build
  end
  
  def create
    @wager = current_user.wagers.build(wager_params)
    
    if @wager.save
      redirect_to @wager, notice: 'Wager was successfully created.'
    else
      # Re-populate dropdowns for the form
      populate_form_data
      render :new, status: :unprocessable_entity
    end
  end
  
  def update
    if @wager.update(wager_params)
      redirect_to @wager, notice: 'Wager was successfully updated.'
    else
      # Re-populate dropdowns for the form
      populate_form_data
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @wager.destroy
    redirect_to wagers_url, notice: 'Wager was successfully deleted.'
  end
  
  private
  
  def set_wager
    @wager = current_user.wagers.find(params[:id])
  end
  
  def wager_params
    params.require(:wager).permit(:date, :amount, :odds, :result, :sportsbook, :tags)
  end
  
  def filter_wagers(wagers)
    # Filter by tag
    if params[:tag].present?
      wagers = wagers.where("tags ILIKE ?", "%#{params[:tag]}%")
    end
    
    # Filter by sportsbook
    if params[:sportsbook].present?
      wagers = wagers.where(sportsbook: params[:sportsbook])
    end
    
    # Filter by date range
    if params[:start_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      wagers = wagers.where("date >= ?", start_date) if start_date
    end
    
    if params[:end_date].present?
      end_date = Date.parse(params[:end_date]) rescue nil
      wagers = wagers.where("date <= ?", end_date) if end_date
    end

    def populate_form_data
    # Get data for any dropdowns or form helpers if needed
    all_wagers = current_user.wagers
    @all_sportsbooks = all_wagers.where.not(sportsbook: [nil, ''])
                                .distinct
                                .pluck(:sportsbook)
                                .sort
  end
    
    wagers
  end
end