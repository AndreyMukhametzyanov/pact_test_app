class User < ApplicationRecord
  before_save :set_full_name

  has_and_belongs_to_many :interests
  has_and_belongs_to_many :skills

  validates :name, :patronymic, :email, :age, :nationality, :country, :gender, presence: true
  validates :email, uniqueness: true
  validates :gender, inclusion: { in: %w[male female] }
  validates :age, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
  validates_associated :interests
  validates_associated :skills

  def set_full_name
    self.full_name = "#{surname} #{name} #{patronymic}"
  end
end
