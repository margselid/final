# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :places do
  primary_key :id
  String :place_name
  String :description, text: true
  String :address
  String :city
  String :state
  String :zip
  String :country
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :place_id
  foreign_key :user_id
  Boolean :like
  String :headline
  String :comments, text: true
end
DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end

# Insert initial (seed) data
places_table = DB.from(:places)

places_table.insert(place_name: "The Wormhole Coffee", 
                    description: "80s-themed rustic coffee shop, complete with a DeLorean, pouring locally roasted coffee.",
                    address: "1462 N Milwaukee Ave",
                    city: "Chicago",
                    state: "IL",
                    zip: "60622",
                    country: "USA")

places_table.insert(place_name: "Everybody's Coffee", 
                    description: "This cheery coffeehouse with long bar tables offers baked goods made on-site plus frequent events.",
                    address: "935 W Wilson Ave",
                    city: "Chicago",
                    state: "IL",
                    zip: "60640",
                    country: "USA")
