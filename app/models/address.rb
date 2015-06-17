class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  validates :street, :locality, :region, :country, :postal_code, presence: true
end
