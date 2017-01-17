class Category
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true, :length => 140

  belongs_to :list
  has n, :items
end
