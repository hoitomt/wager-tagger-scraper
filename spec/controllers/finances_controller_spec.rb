require 'spec_helper'

describe Api::V1::FinancesController do

  let(:ticket1){create :ticket, amount_wagered: 10.0, amount_to_win: 9.09, outcome: "Won"}
  let(:ticket2){create :ticket, amount_wagered: 5.00, amount_to_win: 4.55, outcome: "Won"}
  let(:ticket3){create :ticket, amount_wagered: 10.0, amount_to_win: 9.09, outcome: "Lost"}
  let(:ticket4){create :ticket, amount_wagered: 10.0, amount_to_win: 9.09, outcome: "Lost"}
  let(:ticket5){create :ticket, amount_wagered: 10.0, amount_to_win: 9.09, outcome: "Pending"}
  let(:ticket6){create :ticket, amount_wagered: 30.0, amount_to_win: 9.09, outcome: "Pending"}

  let(:tag1){create :tag, name: "Homer"}
  let(:tag2){create :tag, name: "Bart"}

  before do
    create(:ticket_tag, tag: tag1, ticket: ticket1, amount: 5)
    create(:ticket_tag, tag: tag2, ticket: ticket1, amount: 5)
    create(:ticket_tag, tag: tag1, ticket: ticket2, amount: 5)
    create(:ticket_tag, tag: tag1, ticket: ticket3, amount: 10)
    create(:ticket_tag, tag: tag1, ticket: ticket4, amount: 5)
    create(:ticket_tag, tag: tag2, ticket: ticket4, amount: 5)
    create(:ticket_tag, tag: tag1, ticket: ticket5, amount: 10)
    create(:ticket_tag, tag: tag1, ticket: ticket6, amount: 15)
    create(:ticket_tag, tag: tag2, ticket: ticket6, amount: 15)

    login
  end

  describe "GET index" do
    it "returns success" do
      get :index
      expect(response.status).to eq(200)
    end

    it "performs the calculations correctly" do
      get :index
      j_response = JSON.parse(response.body)
      tag1_finances = j_response.find{|tag| tag['name'] == tag1.name}
      tag1_finances['won'] = (9.09 / 2)
      tag1_finances['lost'] = (10 + 10)
      tag1_finances['pending'] = (10 + 15)
      tag1_finances['total'] = (5 + 5 + 10 + 5 + 10 + 15)

      tag2_finances = j_response.find{|tag| tag['name'] == tag2.name}
      tag2_finances['won'] = (9.09 / 2)
      tag2_finances['lost'] = (5)
      tag2_finances['pending'] = (15)
      tag2_finances['total'] = (5 + 5 + 15)
    end
  end
end
