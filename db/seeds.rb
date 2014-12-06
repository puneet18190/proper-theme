# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:username => "admin", :email => "admin@gmail.com", :password => "12345678", :password_confirmation => "12345678", :address => "address", :phone => "9876543210", :status => "admin", :confirmed_at => Time.now)

Property.create(:address1 => "16 Rectory Place", :address2 => "Bensham",:address3 => "Gateshead",:amount => "395",:bath => "1",:beds => "1",:parking =>"1", :description => "One bedroom ground floor flat with gas central heating", :visibility => "1",:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 1XN")
Property.create(:address1 => "25 Rectory Place", :address2 => "Bensham",:address3 => "Gateshead",:amount => "450",:bath => "2",:beds => "3",:parking =>"1", :description => "Very large, recently decorated throughout 3 bed room maisonette", :visibility => "1",:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 1XN")

#  t.string   "address1"
#  t.string   "address2"
#  t.string   "address3"
#  t.decimal  "amount"
#  t.integer  "bath"
#  t.integer  "beds"
#  t.boolean  "parking"
#  t.string   "image1"
#  t.string   "image2"
#  t.string   "image3"
#  t.string   "image4"
#  t.string   "image5"
#  t.string   "image6"
#  t.text     "description"
#  t.date     "date"
#  t.boolean  "visibility"
#  t.datetime "created_at"
#  t.datetime "updated_at"
#  t.string   "category"
#  t.decimal  "price"
#  t.string   "name"
#  t.integer  "postcode"
# t.boolean  "sold"
#  t.boolean  "let"
#  t.boolean  "featured"
#  t.date     "s_date"
#  t.date     "l_date"
#  t.date     "r_date"
#  t.integer  "user_id"
#  t.boolean  "approve",     default: false
#end