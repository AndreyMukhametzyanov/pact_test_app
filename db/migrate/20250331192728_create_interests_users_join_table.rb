class CreateInterestsUsersJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_join_table :users, :interests do |t|
      t.index [:user_id, :interest_id], unique: true, name: 'index_interests_users_on_user_and_interest'
      t.index [:interest_id, :user_id], unique: true, name: 'index_interests_users_on_interest_and_user'
    end
  end
end
