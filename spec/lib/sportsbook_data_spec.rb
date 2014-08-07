require 'spec_helper'

describe SB::SportsbookData do
  subject {SB::SportsbookData.new('user', 'password')}
  let(:wager_data){Fixtures.raw_wager_data.to_s}
  let(:multi_page_wager_data){Fixtures.multi_page_raw_data.to_s}

  describe '#more_pages' do
    it 'returns true for multipage data' do
      expect(subject.send(:more_pages?, multi_page_wager_data)).to be_truthy
    end

    it 'returns false for single page data' do
      expect(subject.send(:more_pages?, wager_data)).to be_falsey
    end
  end
end