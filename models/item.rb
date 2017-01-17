class Item
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true, :length => 140
  property :crossed, Boolean, :default => false
  property :value, Float
  property :unit, String

  belongs_to :category
end
