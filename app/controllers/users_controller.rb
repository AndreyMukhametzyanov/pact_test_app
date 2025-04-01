class UsersController < ApplicationController
  def create
    outcome = Users::Create.run(user_params)

    if outcome.valid?
      render json: outcome.result, status: :created
    else
      render json: { errors: outcome.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :surname, :name, :patronymic, :email, :age,
      :nationality, :country, :gender, :skills,
      interests: []
    )
  end
end
