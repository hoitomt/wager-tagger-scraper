class Tag < ActiveRecord::Base
  has_many :cash
  has_many :ticket_tags
  has_many :tickets, through: :ticket_tags
end
