class SB::ParseTickets

	class << self
		def create_tickets(ndoc)
			result_tables(ndoc).map do |table|
				build_ticket(table)
			end
		end

		def result_tables(ndoc)
			result_tables = ndoc.css('div#wagerDetails > table > tr > td > div > table')
			result_tables ||= []
		end

		def build_ticket(table)
			ticket = Ticket.new(
				:sb_bet_id => sb_bet_id(table),
				:wager_date => sb_wager_date(table),
				:wager_type => sb_wager_type(table),
				:amount_wagered => sb_amount_wagered(table),
				:amount_to_win => sb_amount_to_win(table),
				:outcome => sb_outcome(table)
			)
			if ticket.save
				create_line_items(table, ticket)
				ticket
			end
		end

		def sb_bet_id(table)
			bet_id_match = bet_id_row(table).to_s.match(%r{BET ID=\d*})
			bet_id_match ? bet_id_match.to_s.split('=')[1].to_i : 0
		end

		def sb_wager_date(table)
			wd = wager_details_rows(table)[0].css('> td > span')[1]
			wd = wd.children[0].content
			wd.gsub!('ET', '')
			Time.strptime(wd, "%m/%d/%y %H:%M")
		end

		def sb_wager_type(table)
			wager_type = wager_details_rows(table)[0].css('> td > span')[0]
			wager_type.children[0].content
		end

		def sb_amount_wagered(table)
			match_txt = wager_amounts(table).to_s.match(%r{bet \d*\W\d*})
			match_txt.to_s.split(' ')[1] if match_txt
		end

		def sb_amount_to_win(table)
			match_txt = wager_amounts(table).to_s.match(%r{to win \d*\W\d*})
			match_txt.to_s.split(' ')[2] if match_txt
		end

		def sb_outcome(table)
			match_txt = outcome_dirty(table).children[0].to_s
			match_txt.to_s.split(' ').last if match_txt
		end

		def create_line_items(table, ticket)
			games(table).each do |game|
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

		def ticket_rows(table)
			ticket_row = table.css('tr')
			ticket_row ||= []
		end

		def bet_id_row(table)
			ticket_rows(table)[0]
		end

		def wager_details_rows(table)
			ticket_rows(table)[1].css('> td > table > tr')
		end

		def wager_amounts(table)
			wager_details_rows(table)[1].css('> td > span')[0]
		end

		def outcome_dirty(table)
			wager_details_rows(table)[1].css('> td > span')[1]
		end

		def game_details_row(table)
			size = ticket_rows(table).size
			ticket_rows(table)[2..size]
		end

		def games(table)
			games = game_details_row(table).css('table')
			games ||= Nokogiri::HTML ''
		end

		def teams(game)
			game_row = game.css('tr').last
			# p "Teams Game Row #{game_row}"
			teams = game_row.css('span')[0].try(:children)
			teams ||= ''
			teams.to_s.split(line_separator)
		end

		def away_data(game)
			# p "Away Data #{game}"
			data = teams(game).first.gsub(/<(.*?)>/, '').strip
			data ||= []
			data.split(' ')
		end

		def home_data(game)
			data = teams(game).last.gsub(/<(.*?)>/, '').strip
			data ||= []
			data.split(' ')
		end

		def away_team(game)
			team = away_data(game)
			team.pop if team.last =~ /^\d+$/
			team.join(' ')
		end

		def away_score(game)
			data = away_data(game)
			data.last =~ /^\d+$/ ? data.last : nil
		end

		def home_team(game)
			team = home_data(game)
			team.pop if team.last =~ /^\d+$/
			team.join(' ')
		end

		def home_score(game)
			data = home_data(game)
			data.last =~ /^\d+$/ ? data.last : nil
		end

		def time_and_spread(game)
			time_spread = game.css('td').last.children
			time_spread = time_spread.css('span').first.children
			time_spread ||= ''
			time_spread.to_s.split(line_separator)
		end

		def game_date(game)
			wd = time_and_spread(game).first
			wd.gsub!('ET', '')
			wd.gsub!(/\(|\)/, ' ').try(:strip!)
			Time.strptime(wd, "%m/%d/%y %H:%M")
		rescue
			# invalid date
		end

		def game_spread(game)
			time_and_spread(game).last.try(:strip)
		end

		def line_separator
			line_separator = /<br>/
		end
	end
end
