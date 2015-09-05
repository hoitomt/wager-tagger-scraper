require 'spec_helper'

describe Api::V1::TicketsController do
  describe "GET tickets" do

    describe "unauthenticated" do
      it "is forbidden" do
        get :index
        expect(response.status).to eq(401)
      end
    end

    describe "authenticated" do
      before { login }

      it "is success" do
        get :index
        expect(response.status).to eq(200)
      end

      it "returns a ticket" do
        ticket = create :ticket
        get :index
        expect(JSON.parse(response.body).first['id']).to eq(ticket.id)
      end
    end

  end
end
