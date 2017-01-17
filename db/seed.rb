require 'faker'

class Seeder

  def self.seed!
    users
    lists
    user_lists
    categories
    items
  end

  def self.users
      User.create(name: "Vilhelm Melkstam",
                  email: "vilhelm.melkstam@gmail.com",
                  password: "Hej")

      User.create(name: "Pelle K.Lund",
                  email: "tramstrams@gmail.com",
                  password: "Hej")

      10.times do
         User.create(name: Faker::Name.name,
                  email: Faker::Internet.email,
                  password: "Hej")
      end
  end

  def self.lists
    List.create(name: "Hemma")
    List.create(name: "Sommarstugan")
    List.create(name: "Järnhandeln")
    List.create(name: "Till båten")

    5.times do
      List.create(name: Faker::Commerce.department)
    end
  end

  def self.user_lists
    UserList.create(user_id: 1, list_id: 1)
    UserList.create(user_id: 1, list_id: 2)
    UserList.create(user_id: 1, list_id: 3)
    UserList.create(user_id: 2, list_id: 1)
    UserList.create(user_id: 2, list_id: 3)
    UserList.create(user_id: 2, list_id: 4)

    User.all.each_index do |i|
      rand(1..4).times do
        UserList.create(user_id: (i + 1), list_id: rand(1..9)) rescue nil
      end
    end
  end

  def self.categories
    List.all.each do |list|
      Category.create(list_id: list.id, name: "Uncategorized")
    end
    20.times do
      Category.create(list_id: rand(1..9), name: Faker::Hipster.word.capitalize)
    end
  end

  def self.items
    100.times do
      Item.create(name: Faker::Food.ingredient, category_id: rand(1..29))
    end
  end


end
