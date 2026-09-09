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

    #TODO: Skriv routen hämtar alla frukter i databasen

    get "/fruits" do
      @fruits = db.execute("SELECT * FROM products ORDER BY name")
      # ap @fruits
      erb(:"fruits/index")
    end 

    get "/fruits/:id" do |id|
      @fruits = db.execute("SELECT * FROM products WHERE id=?", id).first
      erb(:'fruits/show')
    end 

    

end


# INSERT INTO products (name, tastiness, description) VALUES ("Apelsin",  8, "En stor orange frukt")
