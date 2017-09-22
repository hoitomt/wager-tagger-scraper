require 'spec_helper'

describe SB::ParseTickets do
  let(:wager_data){Fixtures.raw_wager_data_2017}
  let(:panel){SB::ParseTickets.result_panels(wager_data).first}
  let(:game){SB::ParseTickets.games(panel).first}
  let(:line_item){SB::ParseTickets.create_line_item(game)}

  describe "all games from page" do
    it "create_tickets" do
      expect {
        SB::ParseTickets.create_tickets(wager_data)
      }.to change(Ticket, :count).by(15)
    end

    it "result_panels" do
      expect(SB::ParseTickets.result_panels(wager_data).length).to eq(15)
    end
  end

  describe "single ticket" do
    let(:wager_data){Fixtures.raw_wager_data_ad_hock('spec/files/sb_response_adhoc_2017.html')}
    it '#sb_wager_date' do
      expect(SB::ParseTickets.sb_wager_date(panel).to_s).to eq("2017-01-28 17:12:00 -0600")
    end

    it '#game_spread' do
      expect(SB::ParseTickets.game_spread(panel)).to eq('Kansas +7 (-110)')
    end

    it "has the correct bet id" do
      expect(SB::ParseTickets.sb_bet_id(panel)).to eq('513105807')
    end

    it "has the correct wager type" do
      expect(SB::ParseTickets.sb_wager_type(panel)).to eq('Straight Wager')
    end

    it "has the correct amount wagered" do
      expect(SB::ParseTickets.sb_amount_wagered(panel)).to eq('5.00')
    end

    it "has the correct amount to win" do
      expect(SB::ParseTickets.sb_amount_to_win(panel)).to eq('4.55')
    end

    it "has the correct outcome" do
      expect(SB::ParseTickets.sb_outcome(panel)).to eq('Wager Won')
    end

  end

  describe "single game" do
    it "has the correct away_team" do
      expect(line_item[:away_team]).to eq('Kansas')
    end

    it "has the the correct home_team" do
      expect(line_item[:home_team]).to eq('Kentucky')
    end

    it "has the correct away_score" do
      expect(line_item[:away_score]).to eq('79')
    end

    it "has the correct home_score" do
      expect(line_item[:home_score]).to eq('73')
    end

    it "has the correct line_item_spread" do
      expect(line_item[:line_item_spread]).to eq('Kansas +7 (-110)')
    end

    it 'has the correct description' do
      expect(line_item[:description]).to eq('Kansas +7 (-110)')
    end
  end

  describe "parlay bet" do
    let(:panel){SB::ParseTickets.result_panels(wager_data)[13]}
    let(:game){SB::ParseTickets.games(panel).first}
    let(:line_item){SB::ParseTickets.create_line_item(game)}
    let(:ticket){ create :ticket }

    it 'correctly splits a game' do
      expect{
        SB::ParseTickets.create_line_items(panel, ticket)
      }.to change{ TicketLineItem.count }.by(2)
    end
  end

  describe "money line bet" do
    let(:panel){SB::ParseTickets.result_panels(wager_data)[5]}
    let(:game){SB::ParseTickets.games(panel).first}
    let(:line_item){SB::ParseTickets.create_line_item(game)}

    it "has the correct away_team" do
      expect(line_item[:away_team]).to eq('Houston Texans')
    end

    it "has the the correct home_team" do
      expect(line_item[:home_team]).to eq('New England Patriots')
    end

    it "has the correct away_score" do
      expect(line_item[:away_score]).to eq('16')
    end

    it "has the correct home_score" do
      expect(line_item[:home_score]).to eq('34')
    end

    it "has the correct line_item_spread" do
      expect(line_item[:line_item_spread]).to eq('Houston Texans +900')
    end
  end

  describe 'funky super bowl line - national anthem' do
    let(:wager_data){Fixtures.sb_super_bowl_2017}
    let(:panel){SB::ParseTickets.result_panels(wager_data).first}
    let(:game){SB::ParseTickets.games(panel).first}
    let(:line_item){SB::ParseTickets.create_line_item(game)}

    it 'sets the description' do
      expect(line_item[:description]).to eq "How Long Will it Take Luke Bryan to Sing the US National Anthem (From his first to last note) | Under 127.5 (+120)"
    end

  end

end
