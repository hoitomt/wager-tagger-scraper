class Cash < ActiveRecord::Base
  belongs_to :tag

  validates_within :amount, :set => 1..100000
end
