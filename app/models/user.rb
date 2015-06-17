class User < ActiveRecord::Base
  has_one :employer, dependent: :destroy
  accepts_nested_attributes_for :employer
  has_one :mailing_address, as: :addressable, class_name: "::Address", dependent: :destroy
  accepts_nested_attributes_for :mailing_address
  validates :username, :email, :mailing_address, :employer, presence: true
end
