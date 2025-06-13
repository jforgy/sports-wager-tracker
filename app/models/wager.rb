class Wager < ApplicationRecord
  belongs_to :user
end
class Wager < ApplicationRecord
  belongs_to :user
  
  validates :date, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :odds, presence: true
  validates :result, presence: true, inclusion: { in: %w[Win Loss Push] }
  validates :sportsbook, presence: true
  
  scope :wins, -> { where(result: 'Win') }
  scope :losses, -> { where(result: 'Loss') }
  scope :pushes, -> { where(result: 'Push') }
  
  def profit_loss
    case result
    when 'Win'
      calculate_winnings
    when 'Loss'
      -amount
    when 'Push'
      0
    end
  end
  
  private
  
  def calculate_winnings
    # Handle American odds format (+150, -110, etc.)
    if odds.start_with?('+')
      odds_value = odds[1..-1].to_f
      amount * (odds_value / 100)
    elsif odds.start_with?('-')
      odds_value = odds[1..-1].to_f
      amount * (100 / odds_value)
    else
      # Handle decimal odds (2.5, 1.8, etc.)
      odds_value = odds.to_f
      amount * (odds_value - 1)
    end
  end
end