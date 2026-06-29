class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  has_many :portfolios, dependent: :destroy
  has_many :budget_goals, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :alerts, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
