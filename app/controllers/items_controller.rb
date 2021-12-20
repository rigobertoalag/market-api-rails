class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index, :items_by_category]
  before_action :set_item, only: [:show, :items_by_user]
  before_action :set_user, only: [:create, :items_by_user, :item_params]
  
  def index   
    @items = Item.all

    render json: {
      links: {self: set_current_url},
      data: {type: 'items', attributes: @items}
    }
  end

  def show
    @item = set_item

    @i = @item.name,  @item.description , @item.created_at

    render json: {
      links: {self: set_current_url},
      data: {type: 'items', id: @item.id, attributes: @i }
    }
  end

  def new
    @item = Item.new
  end

  def create
    if current_user.admin?
      @item = Item.create(item_params)
      if @item.save
        @i = @item.name,  @item.description , @item.created_at
        render json: {
          data: {type: 'items', id: @item.id, attributes: @i },
          links: {self: set_current_url}
        }
      else
        render json: {
          status: 406,
          code: "ESI",
          title: "Error on save item",
          detail: @item.errors.full_messages,
        }, status: :not_acceptable
      end
    else
      render json: { error: true, message: "No tienes permiso" }
    end
  end

  def edit
  end

  def items_by_user

    @param = params[:id].to_i
    @user = set_user
    
    if @param == @user
      @res = Item.where(user_id: @user)
      render json: { success: true, item: @res }
    else
      render json: { success: false, error: "No tiene permisos para ver esa informacion" }
    end
  end

  def items_by_category
    @items = set_category

    render json: {
      links: {self: set_current_url},
      data: {type: 'items', attributes: @items }
    }
  end

  private
  def item_params
      params.require(:item).permit(:name, :description, :price, :category_id).with_defaults(user_id: set_user)
  end

  def set_item
    Item.find(params[:id])
  end

  def set_category
    Item.where(category_id: params[:id])
  end

  def set_user
    current_user.id
  end

  def set_current_url
    request.original_url
  end
end
