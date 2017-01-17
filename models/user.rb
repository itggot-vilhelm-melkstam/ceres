class User
	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true
	property :email, String, :required => true, :unique => true, :length => 256
	property :password, BCryptHash, :required => true

  has n, :user_lists
  has n, :lists, through: :user_lists
end
