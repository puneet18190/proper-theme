class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.email=="admin@gmail.com"
      can :manage, :all
    else
      can :read, :all
      can :create, Property
      can :update, Property

    end
  end
end
