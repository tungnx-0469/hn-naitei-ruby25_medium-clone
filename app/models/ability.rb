# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :update, :destroy, to: :modify
    can :read, :all
    return unless user.present?

    can :create, Article
    can :modify, Article, user_id: user.id
    can :modify, User, id: user.id
  end
end
