# frozen_string_literal: true

class RecipePolicy < ApplicationPolicy
  def update?
    owner?
  end

  def destroy?
    owner?
  end

  private

  def owner?
    user == record.user
  end
end
