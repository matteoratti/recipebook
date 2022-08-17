# frozen_string_literal: true

class RecipePolicy < ApplicationPolicy
  def create?
    false
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def publish?
    owner?
  end

  def archive?
    owner?
  end

  private

  def owner?
    user == record.user
  end
end
