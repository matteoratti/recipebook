# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include HasLikes

  has_many :liked, class_name: 'Like', dependent: :nullify
  has_many :recipes, dependent: :destroy
end
