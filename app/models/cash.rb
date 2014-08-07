class Cash < ActiveRecord::Base
  belongs_to :tag

  validates :amount, numericality: true
end
