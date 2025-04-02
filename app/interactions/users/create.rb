class Users::Create < ActiveInteraction::Base
  string :surname, :name, :patronymic, :email, :nationality, :country, :gender
  string :skills
  integer :age
  array :interests

  validates :age, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
  validates :name, :patronymic, :email, :age, :nationality, :country, :gender, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :gender, inclusion: { in: %w[male female] }

  def execute
    user = User.create!(user_params)

    add_interests(user)
    add_skills(user)

    user
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "User creation failed: #{e.message}")
    nil
  rescue => e
    errors.add(:base, e.message)
    nil
  end

  private

  def user_params
    {
      surname:, name:, patronymic:, email:, age:,
      nationality:, country:, gender:
    }
  end

  def add_interests(user)
    return if interests.blank?

    interests.each do |interest_name|
      interest = Interest.find_or_create_by!(name: interest_name)
      user.interests << interest unless user.interests.exists?(interest.id)
    end
  end

  def add_skills(user)
    return if skills.blank?

    skills.split(',').each do |skill_name|
      skill = Skill.find_or_create_by!(name: skill_name.strip)
      user.skills << skill unless user.skills.exists?(skill.id)
    end
  end
end
