class CreateSkillsUsersJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_join_table :users, :skills do |t|
      t.index [ :user_id, :skill_id ], unique: true, name: 'index_skills_users_on_user_and_skill'
      t.index [ :skill_id, :user_id ], unique: true, name: 'index_skills_users_on_skill_and_user'
    end
  end
end
