class CollectionsController < ApplicationController
  def index
    @collections = current_user.collections
  end

  def show
    @collection = current_user.collections.find(params[:id])
    @thoughts = Thought.where(collection_id: @collection.id)
  end

 def update
  @collection = Collection.find(params[:id])
  @collection.update(collection_params)
  @collection.save
  redirect_to collections_path
 end

 private

 def collection_params
  params.require(:collection).permit(:title, :description)
 end
end
