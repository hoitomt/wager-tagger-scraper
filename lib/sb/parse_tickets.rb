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
	    if existing_ticket = Ticket.where(sb_bet_id: ticket.sb_bet_id).first
	      existing_ticket.update_attributes(outcome: ticket.outcome, amount_to_win: ticket.amount_to_win)
	      update_line_items(panel, existing_ticket)
	      existing_ticket
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
			panel.xpath("div[contains(@class,'tkt-details')]//span[contains(@id, 'betWinAmt')]").text
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
				line_item_spread: game_spread(game),
				description: description(game)
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

		def description(game)
			ed_desc = game.xpath("div//span[contains(@id, 'edDesc')]").text.try(:strip)
			spread = game_spread(game)

			desc = []
			desc << ed_desc if ed_desc.length > 0
			desc << away_team(game) if spread =~ /\// # this appears to correlate
			desc << spread
			desc.compact.join(" | ")
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
	end
end
