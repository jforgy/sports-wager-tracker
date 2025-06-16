class WagersController < ApplicationController
  before_action :set_wager, only: [:show, :edit, :update, :destroy]
  
  def index
    @wagers = current_user.wagers.order(date: :desc)
    @total_wagered = @wagers.sum(:amount)
    @total_profit_loss = @wagers.sum(&:profit_loss)
    @win_percentage = @wagers.count > 0 ? (@wagers.wins.count.to_f / @wagers.count * 100).round(1) : 0
    
    # Calculate ROI
    @roi_percentage = @total_wagered > 0 ? ((@total_profit_loss / @total_wagered) * 100).round(1) : 0
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
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @wager.update(wager_params)
      redirect_to @wager, notice: 'Wager was successfully updated.'
    else
      render :edit
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
end