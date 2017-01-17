class UserList
  include DataMapper::Resource

  belongs_to :user, key: true
  belongs_to :list, key: true
end
