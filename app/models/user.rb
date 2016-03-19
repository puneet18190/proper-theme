# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  address                :string(255)
#  phone                  :string(255)
#  status                 :string(255)
#  payment                :boolean          default(FALSE)
#  search                 :string(255)
#  fb_token               :string(255)
#  plan                   :string(255)      default("free")
#  validity               :datetime
#  title                  :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  address1               :string(255)
#  address2               :string(255)
#  address3               :string(255)
#  postcode               :string(255)
#  mobile                 :string(255)
#  employment             :string(255)
#  price                  :integer
#  deposit                :string(255)
#  tenancy                :integer
#  student                :string(255)
#  benefit                :string(255)
#  pets                   :string(255)
#  smoker                 :string(255)
#  property_type          :string(255)
#  beds                   :integer
#  bath                   :integer
#  max_price              :integer
#  furnished              :string(255)
#  garden                 :string(255)
#  ensuite                :string(255)
#  parking                :string(255)
#  gas_ch                 :string(255)
#  dg                     :string(255)
#  tenancy_type           :string(255)
#  dob                    :date
#  last_name              :string(255)
#  avatar                 :string(255)
#  additional_info        :text
#  supporting_doc         :string(255)
#  tenant_status          :string(255)
#  notes                  :text
#  tenant_property_id     :integer
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'httparty'
class User < ActiveRecord::Base
  include HTTParty
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :properties, dependent: :destroy
  has_many :contact_notes
  Roles = [ :admin , :default ]
  acts_as_messageable
  after_create :notify_to_admin
  def is?( requested_role )
    self.role == requested_role.to_s
  end

  validates_inclusion_of :status, in: %w{tenant landlord admin}
  after_initialize :set_default_state, if: :new_record?

  mount_uploader :avatar, AvatarUploader


  def set_default_state
    state = 'tenant'
  end



  def name
    email
  end

  def mailboxer_email(object)
    email
  end

  def notify_to_admin
    UserMailer.notify_to_admin(self).deliver
    @setting = Setting.all[0]
    if !@setting.sms_destination_no.blank? && @setting.send_sms_on_signup
      HTTParty.post("https://call-api.gradwell.com/0.9.3/sms",:body=>{ 
        :auth=>'4KPDJWZRFOXXS50KXPOA4VTM4S', 
        :originator=>441915805900, 
        :destination=>@setting.sms_destination_no, 
        :message=>"New User #{self.first_name} #{self.last_name} registered on SealProperies as a #{self.status}."})
    end
  end
end

  #
  # def password_required?
  #   false
  # end
  #
  # def email_required?
  #   false
  # end


