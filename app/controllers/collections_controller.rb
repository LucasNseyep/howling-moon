class CollectionsController < ApplicationController
  def index
    @collections = current_user.collections
  end

  def show
    @collection = current_user.collections.find(params[:id])
  end
end
