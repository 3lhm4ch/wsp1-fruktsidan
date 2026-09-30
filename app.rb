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
      @fruits = db.execute("SELECT * FROM products ORDER BY name")
      erb(:"fruits/index")
    end 

    get "/fruits/new" do
      erb(:"fruits/new")
    end

    get "/fruits/:id" do |id|
      @fruits = db.execute("SELECT * FROM products WHERE id=?", id).first
      erb(:'fruits/show')
    end 

    get "/fruits/:id/edit" do |id|
      @fruits = db.execute("SELECT * FROM products WHERE id=?", id).first
      erb(:'fruits/edit')
    end

    post "/fruits/edit" do
      db.execute("UPDATE products SET name = '#{params["name"]}', tastiness = '#{params["taste"]}', description = '#{params["desc"]}', origin = '#{params["origin"]}' WHERE id=#{params["id"]}")
      redirect("/fruits")
    end

    post "/fruits/:id/delete" do |id|
      db.execute("DELETE FROM products WHERE id=?", id)
      redirect("/fruits")
    end

    post "/fruits" do
      db.execute("INSERT INTO products (name, tastiness, description, origin) VALUES ('#{params["name"]}', #{params["taste"]}, '#{params["desc"]}', '#{params["origin"]}')")
      redirect("/fruits")
    end
end


# INSERT INTO products (name, tastiness, description) VALUES ("Apelsin",  8, "En stor orange frukt")
