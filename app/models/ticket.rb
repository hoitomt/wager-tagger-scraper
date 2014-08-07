class Ticket < ActiveRecord::Base
  has_many :ticket_line_items, dependent: :destroy
  has_many :ticket_tags, dependent: :destroy
  has_many :tags, through: :ticket_tags

  validates_uniqueness_of :sb_bet_id

  def self.search(params)
    tickets = Ticket.order('wager_date DESC')
    if params[:page].to_i > 1
      limit = params.fetch(:limit, 0).to_i
      offset = (params[:page].to_i - 1) * limit
      tickets = tickets.limit(limit).offset(offset)
    end
    tickets
  end
end
