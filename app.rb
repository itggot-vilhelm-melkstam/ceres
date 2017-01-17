class App < Sinatra::Base
  enable :sessions

  get '/' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      redirect '/lists'
    else
      slim :login, layout: false
    end
  end

  get '/lists' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @lists = List.all.select {|list| list.users.include? @user }
      @name = "Lists"
      slim :lists
    else
      redirect '/'
    end
  end

  get '/settings' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      slim :settings
    else
      redirect '/'
    end
  end

  get "/list/:id" do |id|
    if session[:user_id] and (List.get(id).users.include? User.get(session[:user_id]))
      @user = User.get(session[:user_id])
      @list = List.get(id)
      @name = @list.name
      slim :list, :layout => :layout_list
    else
      redirect '/'
    end
  end

  get "/item/:id" do |id|
    if session[:user_id] and (Item.get(id).category.list.users.include? User.get(session[:user_id]))
      @user = User.get(session[:user_id])
      @item = Item.get(id)
      slim :item
    else
      redirect '/'
    end
  end




  post '/settings/:id/update' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @user.update(name: params['name'], email: params['email'])
      redirect '/lists'
    else
      redirect '/'
    end
  end

  post '/lists/new_list' do
    if session[:user_id]
      list = List.create(name: params["list_name"])
      UserList.create(user_id: session[:user_id], list: list)
      redirect back
    else
      redirect '/'
    end
  end

  post '/list/:id/add_item' do |id|
    if session[:user_id] and (List.get(id).users.include? User.get(session[:user_id]))
      list = List.get(id)
      Item.create(name: params['item_name'].capitalize, category: list.categories.first)
      redirect back
    else
      redirect '/'
    end
  end

  post '/list/:id/share' do |id|
    if session[:user_id] and (List.get(id).users.include? User.get(session[:user_id]))
      UserList.create(list_id: id, user: User.first(:email => params["share"]).id)
      redirect back
    else
      redirect '/'
    end
  end

  post '/list/:list_id/item/:item_id/cross' do |list_id, item_id|
    if session[:user_id] and (List.get(list_id).users.include? User.get(session[:user_id]))
      item = Item.get(item_id)
      item.update(:crossed => !item.crossed)
      redirect back
    else
      redirect '/'
    end
  end

  post '/list/:list_id/delete_crossed' do |list_id|
    if session[:user_id] and (List.get(list_id).users.include? User.get(session[:user_id]))
      list = List.get(list_id)
      list.categories.each{|category| category.items(crossed: true).destroy}
      redirect back
    else
      redirect '/'
    end
  end

  post '/list/:list_id/clear' do |list_id|
    if session[:user_id] and (List.get(list_id).users.include? User.get(session[:user_id]))
      list = List.get(list_id)
      list.categories.each{|category| category.items(crossed: false).update(crossed: true)}
      redirect back
    else
      redirect '/'
    end
  end

  post "/item/:id/update" do |id|
    if session[:user_id] and (Item.get(id).category.list.users.include? User.get(session[:user_id]))
      @user = User.get(session[:user_id])
      @item = Item.get(id)
      @item.update(name: params['name'], value: params['value'].to_f, unit: params['unit'])
      if params["new_category"]
        category = Category.new(list_id: @item.category.list.id, name: params["new_category"])
        @item.update(category: category)
      else
        category = @item.category.list.categories.first(name: params["category"])
        @item.update(category: category) if category
      end
      redirect "/list/#{@item.category.list.id}"
    else
      redirect '/'
    end
  end

  post '/login' do
    user = User.first(email: params['email'])
    if user && user.password == params['password']
      session[:user_id] = user.id
    end

    redirect '/'
  end

  post '/register' do
    if params['password'] == params['password-repeat']
      user = User.create(name: params['name'],
                         email: params['email'],
                         password: params['password'])
    end
    if user
      session[:user_id] = user.id
      redirect '/'
    else
      redirect '/'
    end
  end

  post '/logout' do
    session.destroy
    redirect '/'
  end





end
