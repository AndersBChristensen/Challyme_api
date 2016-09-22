class Presignup < ActiveRecord::Base

  validates_uniqueness_of :email
  validates :email, presence: true

end
