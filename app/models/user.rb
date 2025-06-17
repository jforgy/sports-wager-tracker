class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
  
  has_many :wagers, dependent: :destroy
end