require 'spec_helper'

describe Api::V1::TicketTagsController do
  before { login }

  let(:ticket){create :ticket}
  let(:tag){create :tag}
  let(:params) {
    {
      "ticket_id"=>ticket.id,
      "tag_id"=>tag.id,
      "amount"=>5,
      "name"=>"Not Needed",
      "id"=>ticket.id
    }
  }

  describe 'create' do
    it "returns success" do
      post :create, params
      expect(response.status).to eq(200)
    end

    it "adds a new ticket_tag" do
      expect{
        post :create, params
      }.to change {TicketTag.count}.by(1)
    end

    it "returns the ticket_tag in the response" do
      post :create, params
      j_response = JSON.parse(response.body)
      expect(j_response.has_key?('id')).to eq true
      expect(j_response['ticket_id']).to eq(ticket.id)
      expect(j_response['tag_id']).to eq(tag.id)
    end
  end

  describe 'destroy' do
    let!(:ticket_tag){create :ticket_tag, ticket: ticket, tag: tag}

    it "returns success" do
      delete :destroy, ticket_id: ticket.id, id: ticket_tag.id
      expect(response.status).to eq(200)
    end

    it "removes the ticket_tag" do
      expect {
        delete :destroy, ticket_id: ticket.id, id: ticket_tag.id
      }.to change{TicketTag.count}.by(-1)
    end
  end
end
