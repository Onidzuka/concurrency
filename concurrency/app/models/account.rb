class Account < ActiveRecord::Base
  attr_accessible :balance

  validates_numericality_of :balance, :greater_than_or_equal_to => 0
end