class TicketTagSerializer < ActiveModel::Serializer
  attributes :id, :ticket_id, :tag_id, :amount, :tag_name

  belongs_to :tag

end
