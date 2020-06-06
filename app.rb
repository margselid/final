# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "geocoder"                                                                    #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################


places_table = DB.from(:places)
reviews_table = DB.from(:reviews)
users_table = DB.from(:users)

# before do
#     # SELECT * FROM users WHERE id = session[:user_id]
#     @current_user = users_table.where(:id => session[:user_id]).to_a[0]
#     puts @current_user.inspect


# Home page (all places)
get "/" do
    # before stuff runs
    @places = places_table.all
    view "places"
end

# Show a single place
get "/places/:id" do
    @users_table = users_table
    # SELECT * FROM place WHERE id=:id
    @place = places_table.where(:id => params["id"]).to_a[0]
    # SELECT * FROM reviews WHERE place_id=:id
    @reviews = reviews_table.where(:place_id => params["id"]).to_a
    # SELECT COUNT(*) FROM reviews WHERE place_id=:id AND going=1
    @count = reviews_table.where(:place_id => params["id"]).count
    view "place"
end

# Form to create a new review
get "/places/:id/reviews/new" do
    @place = places_table.where(:id => params["id"]).to_a[0]
    view "new_review"
end

# Receiving end of new review form
post "/places/:id/reviews/create" do
    reviews_table.insert(:place_id => params["id"],
                        :like => params["like"],
#                       :user_id => @current_user[:id],
                        :headline => params["headline"],
                        :comments => params["comments"])
    @place = places_table.where(:id => params["id"]).to_a[0]
    view "create_review"
end

# # Form to create a new user
# get "/users/new" do
#     view "new_user"
# end

# # Receiving end of new user form
# post "/users/create" do
#     users_table.insert(:name => params["name"],
#                        :email => params["email"],
#                        :password => params["password"])
#     view "create_user"
# end

# # Form to login
# get "/logins/new" do
#     view "new_login"
# end

# # Receiving end of login form
# post "/logins/create" do
#     puts params
#     email_entered = params["email"]
#     password_entered = params["password"]
#     # SELECT * FROM users WHERE email = email_entered
#     user = users_table.where(:email => email_entered).to_a[0]
#     if user
#         puts user.inspect
#         # test the password against the one in the users table
#         if user[:password] == password_entered
#             session[:user_id] = user[:id]
#             view "create_login"
#         else
#             view "create_login_failed"
#         end
#     else 
#         view "create_login_failed"
#     end
# end

# # Logout
# get "/logout" do
#     session[:user_id] = nil
#     view "logout"
# end
# end