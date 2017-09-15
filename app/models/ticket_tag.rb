class TicketTag < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :tag

  def tag_name
    self.tag.name
  end
end
