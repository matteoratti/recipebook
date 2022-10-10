# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def like?
    user != record && !user.nil?
  end
end
