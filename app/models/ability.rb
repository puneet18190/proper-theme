class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.email=="admin@gmail.com"
      can :manage, :all
    elsif user.status=="admin"
      can :manage, :all
    elsif user.status== "landlord"
      #can :manage, :all
      can :confirm_payment, :all
      can :create, :all
      can :read, :all
      can :update, :all
      can :destroy, :all
    else
       #can :manage, :all
      can :read, :all
      can :search_property, :all
      can :payment, :all
      can :payment_confirmation, :all
    end
  end
end
