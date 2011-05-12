# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

user1 = User.create(:username => 'Ben', :email => 'ben@example.com', :password => '', :password_confirmation => '')
user2 = User.create(:username => 'John', :email => 'john@example.com', :password => '', :password_confirmation => '')
user3 = User.create(:username => 'Chris', :email => 'chris@example.com', :password => '', :password_confirmation => '')
user4 = User.create(:username => 'Steve', :email => 'steve@example.com', :password => '', :password_confirmation => '')
