class CmsAbilityDecorator
  include CanCan::Ability
  def initialize(user)
    user ||= User.new
    can :read, Page
  end
end
