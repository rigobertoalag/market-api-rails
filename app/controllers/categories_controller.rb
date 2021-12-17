class CategoriesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_category, only: [:show]
  before_action :set_user, only: [:create]

  def index
    @categories = Category.all

    render json: {categories: @categories }
  end

  def show
    @category = set_category

    render json: { success: true, category: @category }
  end

  def new
    @category = Category.new
  end

  def create
    if current_user.admin?
      @category = Category.create(category_params)
      if @category.save
        render json: { success: true, message: "Categoria guardada con exito" }
      else
        render json: { error: true, category: @category }
      end
    else
      render json: { error: true, message: "No tienes permiso" }
    end
  end

  def edit
  end

  private 
  def category_params
    params.require(:category).permit(:name, :description)
  end

  def set_category
    Category.find(params[:id])
  end

  def set_user
    current_user.id
  end
end
