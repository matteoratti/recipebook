class StepPolicy < ApplicationPolicy
  def create?
    is_owner?
  end
  
  def update?
    is_owner?
  end

  def destroy?
    is_owner?
  end

  private

  def is_owner?
    user == record.recipe.user
  end
end