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

  private

  def owner?
    user == record.recipe.user
  end
end
