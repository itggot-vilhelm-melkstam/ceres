class List
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true, :length => 140
  property :created_at, DateTime

  has n, :user_lists
  has n, :users, through: :user_lists
  has n, :categories
end
