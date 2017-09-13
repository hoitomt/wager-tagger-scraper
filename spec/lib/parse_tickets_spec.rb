require 'spec_helper'

describe SB::ParseTickets do
  let(:wager_data){Fixtures.raw_wager_data_2017}
  let(:table){SB::ParseTickets.result_tables(wager_data).first}
  let(:game){SB::ParseTickets.games(table).first}
  let(:line_item){SB::ParseTickets.create_line_item(game)}

  describe "all games from page" do
    it "create_tickets" do
      expect {
        SB::ParseTickets.create_tickets(wager_data)
      }.to change(Ticket, :count).by(7)
    end

    it "result_tables" do
      expect(SB::ParseTickets.result_tables(wager_data).length).to eq(7)
    end
  end

  describe "single ticket" do

    it "has the correct bet id" do
      expect(SB::ParseTickets.sb_bet_id(table)).to eq(432738671)
    end

    it "has the correct wager type" do
      expect(SB::ParseTickets.sb_wager_type(table)).to eq('Parlay (2 Teams)')
    end

    it "has the correct amount wagered" do
      expect(SB::ParseTickets.sb_amount_wagered(table)).to eq('5.00')
    end

    it "has the correct amount to win" do
      expect(SB::ParseTickets.sb_amount_to_win(table)).to eq('13.45')
    end

    it "has the correct outcome" do
      expect(SB::ParseTickets.sb_outcome(table)).to eq('Lost')
    end

  end

  describe "single game" do
    it "has the correct away_team" do
      expect(line_item[:away_team]).to eq('49ers(SanFrancisco)')
    end

    it "has the the correct home_team" do
      expect(line_item[:home_team]).to eq('Seahawks(Seattle)')
    end

    it "has the correct away_score" do
      expect(line_item[:away_score]).to eq('17')
    end

    it "has the correct home_score" do
      expect(line_item[:home_score]).to eq('23')
    end

    it "has the correct line_item_spread" do
      expect(line_item[:line_item_spread]).to eq('49ers(SanFrancisco) +150')
    end
  end

end
