require 'spec_helper'

describe SB::SportsbookData do
  subject {SB::SportsbookData.new('user', 'password')}
  let(:single_page_wager_data){Fixtures.no_pagination.to_s}
  let(:multi_page_wager_data){Fixtures.sb_super_bowl_2018.to_s}

  describe '#more_pages' do
    it 'returns true for multipage data' do
      expect(subject.send(:more_pages?, multi_page_wager_data)).to be true
    end

    it 'returns false for single page data' do
      expect(subject.send(:more_pages?, single_page_wager_data)).to be false
    end
  end
end
