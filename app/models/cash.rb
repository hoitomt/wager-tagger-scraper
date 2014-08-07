class Cash < ActiveRecord::Base
  belongs_to :tag

  validates_inclusion_of :amount, :set => 1..100000
end
