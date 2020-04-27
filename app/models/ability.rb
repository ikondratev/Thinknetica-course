class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :create, Authorization
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Link, File, Gift]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :profile, User, id: user.id

    can :set_the_best, Answer do |answer|
      user.is_author_of?(answer.question)
    end

    can [:update, :destroy], Link do |link|
      user.is_author_of?(link.linkable)
    end

    can [:like, :dislike], [Answer, Question] do |votable|
      !user.is_author_of?(votable)
    end

    can :canceled_vote, [Answer, Question] do |votable|
      votable.votes.where(user_id: user.id).any?
    end

    can :destroy, ActiveStorage::Attachment do |thing|
      user.is_author_of?(thing.record)
    end

    can :create, Subscription do |thing|
      !user.subscribed?(thing.question)
    end

    can :destroy, Subscription do |thing|
      user.subscribed?(thing.question)
    end
  end
end
