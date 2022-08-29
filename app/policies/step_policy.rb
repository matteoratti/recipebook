# frozen_string_literal: true

class StepPolicy < ApplicationPolicy
  def create?
    owner?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def like?
    user != record.recipe.user && !user.nil?
  end

  private

  def owner?
    user == record.recipe.user
  end
end
