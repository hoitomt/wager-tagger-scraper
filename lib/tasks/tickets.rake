namespace :tickets do
  desc "Get all ticket data"
  task :get_all => :environment do
    puts "Get all ticket data"
    sb = SB::SportsbookData.new(ENV['SB_USERNAME'], ENV['SB_PASSWORD'])
    tickets = sb.all_tickets
  end

  desc "Get recent ticket data"
  task :get_recent => :environment do
    puts "Get all ticket data"
    sb = SB::SportsbookData.new(ENV['SB_USERNAME'], ENV['SB_PASSWORD'])
    tickets = sb.recent_tickets(Date.today)
  end
end
