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
      can :landlord_payment, :all
      can :confirm_landlord_payment,:all 
      can :facebook_share,:all
    else
       can :manage, :all
      # can :read, :all
      # can :search_property, :all
      # can :payment, :all
      # can :payment_confirmation, :all
      # can :confirm_tenant_payment, :all
      # can :tenant_search, :all
      # can :search, :all
    end
  end
end
