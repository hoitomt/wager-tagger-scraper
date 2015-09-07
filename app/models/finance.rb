class Finance
  attr_accessor :tag_id, :name, :won, :lost, :pending, :total

  def self.all(start_date, stop_date)
    Tag.all.map do |tag|
      finance = self.new(tag, start_date, stop_date)
      next if finance.total == 0
      finance.api_response
    end.compact
  end

  def initialize(tag, start_date=nil, stop_date=nil)
    @tag = tag
    @start_date = start_date
    @stop_date = stop_date
    process
  end

  def process
    ticket_tags.each do |ticket_tag|
      pct_stake = ticket_tag.amount / ticket_tag.ticket.amount_wagered

      case ticket_tag.ticket.outcome.downcase
      when "won"
        self.won += (pct_stake * ticket_tag.ticket.amount_to_win) + ticket_tag.amount
      when "lost"
        self.lost += ticket_tag.amount
      when "pending"
        self.pending += ticket_tag.amount
      end
      self.total += ticket_tag.amount
    end
  end

  def api_response
    {
      tag_id: @tag.id,
      name: @tag.name,
      won: @won.to_f.round(4),
      lost: @lost.to_f.round(4),
      pending: @pending.to_f.round(4),
      total: @total.to_f.round(4)
    }
  end

  def won
    @won ||= 0.0
  end

  def lost
    @lost ||= 0.0
  end

  def pending
    @pending ||= 0.0
  end

  def total
    @total ||= 0.0
  end

  def ticket_tags
    scope = TicketTag.includes(:tag).where(tag_id: @tag.id).joins(:ticket)
    scope = scope.where("tickets.wager_date >= ?", @start_date) if @start_date.present?
    scope = scope.where("tickets.wager_date <= ?", @stop_date) if @stop_date.present?
    @ticket_tags ||= scope
  end
end
