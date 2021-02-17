class UsersController < ApplicationController
  def index
    render jsonapi: User.where(archived: false)
  end

  def update
    user = User.find(params[:id])
    status = user_params[:archived] ? User.statuses[:archived] : User.statuses[:un_archived]

    if user
      if user_params[:archived] == user.archived
        render json: { message: "User is already #{status}." }
      else
        user.update(archived: user_params[:archived])
        user.archive_user_histories.create(user_params)
        render json: { error: "User #{status} successfully." }
      end
    else
      render json: { error: "User not found." }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:archived_by, :archived)
  end
end
