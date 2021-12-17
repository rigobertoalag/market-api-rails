class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index, :items_by_category]
  before_action :set_item, only: [:show, :items_by_user]
  before_action :set_user, only: [:create, :items_by_user, :item_params]
  
  def index   
    @items = Item.all
    
    render json: {items: @items }
  end

  def show
    @item = set_item

    render json: { success: true, item: @item }
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.create(item_params)

    if @item.save
      render json: { success: true, message: "Se guardo con exito" }
    else
      render json: { error: true, item: @item, user: set_user }
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
    @param = params[:id].to_i

    @items = Item.where(category_id: @param)

    render json: { success: true, items: @items }
  end

  private
  def item_params
      params.require(:item).permit(:name, :description, :price, :category_id).with_defaults(user_id: set_user)
  end

  def set_item
    Item.find(params[:id])
  end

  def set_user
    current_user.id
  end
end
