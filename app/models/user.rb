class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  Roles = [ :admin , :default ]

  def is?( requested_role )
    self.role == requested_role.to_s
  end

  validates_inclusion_of :status, in: %w{tenant landlord}
  after_initialize :set_default_state, if: :new_record?


  def set_default_state
    state = 'tenant'
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


