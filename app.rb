require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    get "/fruits" do
      @fruits = db.execute("SELECT * FROM products ORDER BY categories_id, name")
      @categories = db.execute("SELECT * FROM categories")
      erb(:"fruits/index")
    end 

    get "/fruits/new" do
      @categories = db.execute("SELECT * FROM categories")
      erb(:"fruits/new")
    end

    get "/fruits/categories" do
      @categories = db.execute("SELECT * FROM categories")
      erb(:'fruits/categories')
    end

    get "/fruits/:id" do |id|
      @fruits = db.execute("SELECT * FROM products WHERE id=?", id).first
      erb(:'fruits/show')
    end 

    get "/fruits/:id/edit" do |id|
      @fruits = db.execute("SELECT * FROM products WHERE id=?", id).first
      @categories = db.execute("SELECT * FROM categories")
      erb(:'fruits/edit')
    end

    get "/fruits/categories/:id" do |id|
      @fruits = db.execute("SELECT * FROM products WHERE categories_id=?", id)
      @categories = db.execute("SELECT * FROM categories")
      @cat_id = id
      erb(:"fruits/index")
    end

    post "/categories" do
      redirect("/fruits/categories/#{params["categories"]}")
    end 

    post "/fruits/edit" do
      db.execute("UPDATE products SET name = '#{params["name"]}', tastiness = '#{params["taste"]}', description = '#{params["desc"]}', origin = '#{params["origin"]}', categories_id = '#{params["categories_id"]}' WHERE id=#{params["id"]}")
      redirect("/fruits")
    end

    post "/fruits/:id/delete" do |id|
      db.execute("DELETE FROM products WHERE id=?", id)
      redirect("/fruits")
    end

    post "/fruits" do
      db.execute("INSERT INTO products (name, tastiness, description, origin, categories_id) VALUES ('#{params["name"]}', #{params["taste"]}, '#{params["desc"]}', '#{params["origin"]}', '#{params["categories_id"]}')")
      redirect("/fruits")
    end
end