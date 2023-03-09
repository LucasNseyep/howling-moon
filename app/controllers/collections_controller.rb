class CollectionsController < ApplicationController
  def index
    @collections = current_user.collections
  end

  def show
    @collection = current_user.collections.find(params[:id])
    @thoughts = Thought.where(collection_id: @collection.id)
  end

  def edit
    @collection = Collection.find(params[:id])
  end

 def update
  @collection = Collection.find(params[:id])
  @collection.update(collection_params)
  @collection.save
  redirect_to collections_path
 end

 def destroy
  @collection = Collection.find(params[:id])
  @collection.thoughts.each do |thought|
    thought.collection_id = nil
  end
  @collection.save
  # raise
  @collection.destroy
  redirect_to collections_path
 end

 private

 def collection_params
  params.require(:collection).permit(:title, :description)
 end
end
