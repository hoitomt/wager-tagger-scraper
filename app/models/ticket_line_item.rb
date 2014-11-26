class TicketLineItem < ActiveRecord::Base
  belongs_to :ticket

  validates_uniqueness_of :line_item_date, scope: [:away_team, :home_team, :ticket_id]
end
