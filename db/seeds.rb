# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:username => "admin", :email => "admin@gmail.com", :password => "12345678", :password_confirmation => "12345678", :address => "address", :phone => "9876543210", :status => "admin", :confirmed_at => Time.now)

Property.create(:address1 => "16 Rectory Place", :address2 => "Bensham",:address3 => "Gateshead",:amount => "395",:bath => "1",:beds => "1",:parking =>"1", :image1 => "/assets/16rp.jpg", :description => "One bedroom ground floor flat with gas central heating", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 1XN", :approve => true, :payment => true,:user_id=>4)
Property.create(:address1 => "23 Rectory Place", :address2 => "Bensham",:address3 => "Gateshead",:amount => "395",:bath => "1",:beds => "1",:parking =>"1", :image1 => "/assets/25rp.jpg", :image2 => "/assets/Bathroom.JPG", :image3 => "/assets/BedroomA.jpg", :image4 => "/assets/Kitchen&Diner.JPG", :description => "One bedroom ground floor flat with gas central heating", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 1XN", :approve => "true",:payment => true,:user_id=>4)

Property.create(:address1 => "25 Rectory Place", :address2 => "Bensham",:address3 => "Gateshead",:amount => "450",:bath => "2",:beds => "3",:parking =>"1", :image1 => "/assests/25rp.jpg", :description => "Very large, recently decorated throughout 3 bed room maisonette", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 1XN", :approve => true, :payment => true,:user_id=>4)
Property.create(:address1 => "27 Rectory Place", :address2 => "Bensham",:address3 => "Gateshead",:amount => "700",:bath => "2",:beds => "6",:parking =>"1", :image1 => "/assests/27rp.jpg", :description => "Very large, six bed 2 receptions and 2 bathrooms terraced house", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 1XN", :approve => true, :payment => true,:user_id=>4)
Property.create(:address1 => "35 Rectory Place", :address2 => "Bensham",:address3 => "Gateshead",:amount => "450",:bath => "1",:beds => "2",:parking =>"1", :image1 => "/assests/3537rp.jpg", :description => "Two bedroomed gorund floor flat", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 1XN", :approve => true, :payment => true,:user_id=>4)
Property.create(:address1 => "37 Rectory Place", :address2 => "Bensham",:address3 => "Gateshead",:amount => "450",:bath => "1",:beds => "3",:parking =>"1", :image1 => "/assests/3537rp.jpg", :description => "Very large, three bedroomed upper maisonette", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 1XN", :approve => true, :payment => true,:user_id=>4)
Property.create(:address1 => "41 Rectory Place", :address2 => "Bensham",:address3 => "Gateshead",:amount => "450",:bath => "1",:beds => "3",:parking =>"1", :image1 => "/assests/41rp.jpg", :description => "Very large, recently decorated throughout 3 bed room maisonette", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 1XN", :approve => true, :payment => true,:user_id=>4)

Property.create(:address1 => "2 Westminster Street", :address2 => "Saltwell",:address3 => "Gateshead",:amount => "490",:bath => "2",:beds => "3",:parking =>"1", :image1 => "/assests/2west.jpg", :description => "Upper 3 bed room maisonette with family bathroom, ensuite and cloakroam", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 4TS", :approve => true, :payment => true,:user_id=>4)
Property.create(:address1 => "55 Macadam Street", :address2 => "Saltwell",:address3 => "Gateshead",:amount => "450",:bath => "1",:beds => "3",:parking =>"1", :image1 => "/assests/55mac.jpg", :description => "Upper 3 bed room flat", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 4TS", :approve => true, :payment => true,:user_id=>4)

Property.create(:address1 => "3 Maxwell Street", :address2 => "Saltwell",:address3 => "Gateshead",:amount => "450",:bath => "1",:beds => "3",:parking =>"1", :image1 => "/assests/55mac.jpg", :description => "Upper 3 bed room flat", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 4TS", :approve => true, :payment => true,:user_id=>4)
Property.create(:address1 => "20 Arkwright Street", :address2 => "Saltwell",:address3 => "Gateshead",:amount => "450",:bath => "1",:beds => "2",:parking =>"1", :image1 => "/assests/55mac.jpg", :description => "Upper 3 bed room flat", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 4TS", :approve => true, :payment => true,:user_id=>4)
Property.create(:address1 => "21 Westminster Street", :address2 => "Saltwell",:address3 => "Gateshead",:amount => "450",:bath => "1",:beds => "2",:parking =>"1", :image1 => "/assests/55mac.jpg", :description => "Upper 3 bed room flat", :visibility => true,:category => "rent", :price => "450", :name => "Rectory Place", :postcode => "NE8 4TS", :approve => true, :payment => true,:user_id=>4)

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