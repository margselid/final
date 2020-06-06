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
                    address: "1462 N Milwaukee Ave, Chicago, IL 60622")

places_table.insert(place_name: "Everybody's Coffee", 
                    description: "This cheery coffeehouse with long bar tables offers baked goods made on-site plus frequent events.",
                    address: "935 W Wilson Ave, Chicago, IL 60640")

places_table.insert(place_name: "Heritage Outpost", 
                    description: "Heritage Outpost is a little coffee house located at 1325 W. Wilson avenue in the Uptown neighborhood of Chicago, Illinois. Artisanal coffee in a cozy space.",
                    address: "1325 W. Wilson Ave, Chicago, IL 60640")

places_table.insert(place_name: "Emerald City Coffee", 
                    description: "Espresso drinks, light fare & baked goods offered in a warm, brick-lined space with an arty vibe.",
                    address: "1224 W Wilson Ave, Chicago, IL 60640")

places_table.insert(place_name: "Intelligentsia Coffee Broadway Coffeebar", 
                    description: "High-end coffee bar chain serving daily roasted brews in an industrial-chic setting.",
                    address: "3123 N Broadway, Chicago, IL 60657")
