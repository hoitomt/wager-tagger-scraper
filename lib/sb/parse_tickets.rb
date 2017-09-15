class SB::ParseTickets

	class << self
		def create_tickets(ndoc)
			result_panels(ndoc).map do |panel|
				build_ticket(panel)
			end
		end

		def result_panels(ndoc)
			result_panels = ndoc.css('div#searchResult > .panel-primary')
			result_panels ||= []
		end

		def build_ticket(panel)
			ticket = Ticket.new(
				:sb_bet_id => sb_bet_id(panel),
				:wager_date => sb_wager_date(panel),
				:wager_type => sb_wager_type(panel),
				:amount_wagered => sb_amount_wagered(panel),
				:amount_to_win => sb_amount_to_win(panel),
				:outcome => sb_outcome(panel)
			)
			add_or_update_ticket(ticket, panel)
		end

	  def add_or_update_ticket(ticket, panel)
	    if new_ticket = Ticket.where(sb_bet_id: ticket.sb_bet_id).first
	      new_ticket.update_attributes(outcome: ticket.outcome)
	      update_line_items(panel, new_ticket)
	      new_ticket
	    else
	      if ticket.save
					create_line_items(panel, ticket)
					ticket
				end
	    end
	  end

		def sb_bet_id(panel)
			panel.xpath('@id').text
		end

		def sb_wager_date(panel)
			wd = panel.xpath("div[contains(@class,'tkt-details')]//span[contains(@id, 'betDate')]").text
			wd = wd.gsub(/ET|EST/, '').strip
			Time.strptime(wd, "%m/%d/%y %H:%M")
		end

		def sb_wager_type(panel)
			panel.xpath("div[contains(@class,'tkt-details')]//span[contains(@id, 'betDesc')]").text
		end

		def sb_amount_wagered(panel)
			panel.xpath("div[contains(@class,'tkt-details')]//span[contains(@id, 'betAmt')]").text
		end

		def sb_amount_to_win(panel)
			panel.xpath("div[contains(@class,'tkt-details')]//span[contains(@id, 'betPaidAmt')]").text
		end

		def sb_outcome(panel)
			panel.xpath("div[contains(@class,'tkt-details')]//span[contains(@id, 'betResult')]").text
		end

		# Rather than update line items, just delete and recreate
		def update_line_items(panel, ticket)
			ticket.ticket_line_items.destroy_all
			create_line_items(panel, ticket)
		end

		def create_line_items(panel, ticket)
			games(panel).each do |game|
				ticket.ticket_line_items.create(create_line_item(game))
			end
		end

		def create_line_item(game)
			{
				away_team: away_team(game),
				away_score: away_score(game),
				home_team: home_team(game),
				home_score: home_score(game),
				line_item_date: game_date(game),
				line_item_spread: game_spread(game)
			}
		end

		def away_team(game)
			game.xpath("div//span[contains(@id, 'team1')]").text.try(:strip)
		end

		def away_score(game)
			game.xpath("div//span[contains(@id, 'fnScore1')]").text.try(:strip)
		end

		def home_team(game)
			game.xpath("div//span[contains(@id, 'team2')]").text.try(:strip)
		end

		def home_score(game)
			game.xpath("div//span[contains(@id, 'fnScore2')]").text.try(:strip)
		end

		def game_date(game)
			wd = game.xpath("div//span[contains(@id, 'eventTime')]").text
			wd.gsub!(/EST|ET/, '')
			wd = wd.gsub(/\(|\)/, ' ').try(:strip)
			Time.strptime(wd, "%m/%d/%y %H:%M")
		rescue
			# invalid date
		end

		def game_spread(game)
			lis = game.xpath("div//span[contains(@id, 'market')]").text
			lis.try(:strip)
		end

		def games(panel)
			games = panel.xpath("div[contains(@class,'tkt-details')]//div[contains(@id, 'betSel')]")
			games ||= Nokogiri::HTML ''
		end

		# def teams(game)
		# 	game_row = game.css('tr').last
		# 	# p "Teams Game Row #{game_row}"
		# 	teams = game_row.css('span')[0].try(:children)
		# 	teams ||= ''
		# 	teams.to_s.split(line_separator)
		# end

		# def away_data(game)
		# 	# p "Away Data #{game}"
		# 	data = teams(game).first.gsub(/<(.*?)>/, '').strip
		# 	data ||= []
		# 	data.split(' ')
		# end

		# def home_data(game)
		# 	data = teams(game).last.gsub(/<(.*?)>/, '').strip
		# 	data ||= []
		# 	data.split(' ')
		# end

		# def away_team(game)
		# 	team = away_data(game)
		# 	team.pop if team.last =~ /^\d+$/
		# 	team.join(' ')
		# end

		# def away_score(game)
		# 	data = away_data(game)
		# 	data.last =~ /^\d+$/ ? data.last : nil
		# end

		# def home_team(game)
		# 	team = home_data(game)
		# 	team.pop if team.last =~ /^\d+$/
		# 	team.join(' ')
		# end

		# def home_score(game)
		# 	data = home_data(game)
		# 	data.last =~ /^\d+$/ ? data.last : nil
		# end

		# def time_and_spread(game)
		# 	time_spread = game.css('td').last.children
		# 	time_spread = time_spread.css('span').first.children
		# 	time_spread ||= ''
		# 	time_spread.to_s.split(line_separator)
		# end

		# def game_date(game)
		# 	wd = time_and_spread(game).first
		# 	wd.gsub!('ET', '')
		# 	wd.gsub!(/\(|\)/, ' ').try(:strip!)
		# 	Time.strptime(wd, "%m/%d/%y %H:%M")
		# rescue
		# 	# invalid date
		# end

		# def game_spread(game)
		# 	time_and_spread(game).last.try(:strip)
		# end

		# def line_separator
		# 	line_separator = /<br>/
		# end
	end
end
