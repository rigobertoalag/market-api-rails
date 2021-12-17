class CategoriesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_category, only: [:show]
  before_action :set_user, only: [:create]
  

  def index
    @categories = Category.all

    render json: {
      links: {self: set_current_url},
      data: {type: 'categories', attributes: @categories}
    }
  end

  def show
    @category = set_category
    @cat = @category.name,  @category.description , @category.created_at

    render json: {
      links: {self: set_current_url},
      data: {type: 'categories', id: @category.id, attributes: @cat }
    }
  end

  def new
    @category = Category.new
  end

  def create
    if current_user.admin?
      @category = Category.create(category_params)
      if @category.save
        @cat = @category.name, @category.description, @category.created_at
        render json: {
          data: {type: 'categories', id: @category.id, attributes: @cat },
          links: {self: set_current_url}
        }
      else
        @error = 'error'
        # response = http.request_head('/')
        # json_response(@error, :unprocessable_entity)
        render json: {
          status: 406,
          code: "ESD",
          title: "Error on save category",
          detail: @category.errors.full_messages,
        }, status: :not_acceptable
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

  def set_current_url
    request.original_url
  end
end
