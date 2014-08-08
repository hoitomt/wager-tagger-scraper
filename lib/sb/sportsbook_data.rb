class SB::SportsbookData
  attr_accessor :username, :password, :pages

  GLOBAL_START_DATE = Date.new(2013, 7, 1)

  def initialize(username, password)
    @username = username
    @password = password
    @pages = []
  end

  def logged_in?
    logged_in = SB::Sportsbook.get_data(config)
    return !(logged_in =~ /NOT LOGGED IN/)
  end

  def recent_tickets(start_date=nil)
    start_date ||= Date.today - 30.days
    tickets_for_start_date(start_date)
  end

  def all_tickets
    date = GLOBAL_START_DATE
    [].tap do |a|
      while date < Date.today
        tickets_for_start_date(date)
        date += 30.days
      end
    end.flatten.compact
  end

  def tickets_for_start_date(start_date)
    puts "Retrieve tickets for the 30 days after #{start_date}"
    all_pages_of_tickets(start_date, 1)
    @pages.map do |ndoc|
      SB::ParseTickets.create_tickets(ndoc)
    end.flatten.compact
  end

  private

  def all_pages_of_tickets(start_date, page)
    doc = SB::Sportsbook.get_data(config, {start_date: start_date, page: page})
    @pages << polish(doc)
    if more_pages?(doc)
      page += 1
      all_pages_of_tickets(start_date, page)
    else
      return
    end
  end

  def more_pages?(doc)
    ndoc = polish(doc)
    pagination_data = ndoc.css('table#pagination > tr img')
    return false if pagination_data.blank? || pagination_data.length == 0
    img_src = pagination_data.last.attribute('src').value
    !!(img_src =~ /next/)
  end

  def sportsbook
    SB::Sportsbook.new(config)
  end

  def config
    @config ||= SB::Config.new(@username, @password)
  end

  def polish(doc)
    doc.gsub!(/\\r|\\t|\\n|\\/, '')
    doc.gsub!(/\s{2,}/, ' ')
    Nokogiri::HTML(doc)
  end

end
