class CmsAbilityDecorator
  include CanCan::Ability
  def initialize(user)
    can :read, Page
  end
end
