require 'sqlite3'
require_relative '../config'

db = SQLite3::Database.new(DB_PATH)

puts "🧹 Tar bort gamla tabeller..."
db.execute('DROP TABLE IF EXISTS products')
db.execute('DROP TABLE IF EXISTS categories')

puts "🧱 Skapar tabeller..."
db.execute('CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            tastiness INTEGER,
            description TEXT,
            origin TEXT,
            categories_id INTEGER)')

db.execute('CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT)')

puts "🍎 Fyller på med data..."
db.execute('INSERT INTO products (name, tastiness, description, origin, categories_id) VALUES ("Äpple",  7, "En rund frukt som finns i många olika färger.", "Frankrike", 1)')
db.execute('INSERT INTO products (name, tastiness, description, origin, categories_id) VALUES ("Päron",  6, "En nästan rund, men lite avlång, frukt. Oftast mjukt fruktkött.", "belgien", 1)')
db.execute('INSERT INTO products (name, tastiness, description, origin, categories_id) VALUES ("Banan",  4, "En avlång gul frukt.", "Ecuador", 2)')
db.execute('INSERT INTO products (name, tastiness, description, origin, categories_id) VALUES ("Mango",  9, "En god frukt med stor kärna.", "Peru", 4)')
db.execute('INSERT INTO categories (name, description) VALUES ("Stenfrukter", "blabla")')
db.execute('INSERT INTO categories (name, description) VALUES ("Bär", "blabla")')
db.execute('INSERT INTO categories (name, description) VALUES ("Citrus", "blabla")')
db.execute('INSERT INTO categories (name, description) VALUES ("Tropisk", "blabla")')
db.execute('INSERT INTO categories (name, description) VALUES ("Annat", "blabla")')

puts "✅ Databasen är seedad!"
