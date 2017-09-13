class TicketSerializer < ActiveModel::Serializer
  attributes :id, :sb_bet_id, :wager_date, :wager_type, :amount_wagered,
             :amount_to_win, :outcome, :ticket_line_items, :ticket_tags

  has_many :ticket_tags
end
