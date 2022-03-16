class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :no_record_found

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item, only: [:id, :name, :description, :price, :user_id]
  end

  def create
    item = Item.create(items_params)
    user = User.find(params[:user_id])
    user.items << item
    render json: item, status: :created
  end

  private

  def items_params
    params.permit(:name, :description, :price)
  end

  def no_record_found
    render json: {error: "User not found"}, status: :not_found
  end

end
