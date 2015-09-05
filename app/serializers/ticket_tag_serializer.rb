class TicketTagSerializer < ActiveModel::Serializer
  attributes :id, :ticket_id, :tag_id, :amount, :name

  belongs_to :tag

  def name
    tag.name
  end
end
