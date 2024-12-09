class Api::V1::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def index
    render json: UserSerializer.format_user_list(User.all)
  end

  def show
    user = User.find(params[:id])
    user_attributes = user.get_attributes
    render json: UserSerializer.format_user(user_attributes)
  end

  private

  def user_params
    params.permit(:name, :username, :password, :password_confirmation)
  end

  def record_not_found(exception)
    render json: ErrorSerializer.format_not_found(exception), status: :not_found
  end
end