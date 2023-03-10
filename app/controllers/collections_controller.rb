class CollectionsController < ApplicationController
  def index
    @collections = current_user.collections
  end

  def show
    @collection = current_user.collections.find(params[:id])
    @thoughts = Thought.where(collection_id: @collection.id)
  end

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new(collection_params)
    # @collection.user = current_user
    @collection.save
      redirect_to collection_path(@collection)
    # else
    #   render :new, status: :unprocessable_entity
    # end
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
  # THINK THIS WILL WORK BUT NEED TO GO OVER IT ALL AGAIN TOMORROW
  # CURRENTLY NOT LIKING THE DESTROY ON THE disconnect METHOD
  # @collection.thoughts.each do |thought|
  #   thought.disconnect(thought[:id])
  #   thought.save
  # end
  @collection.destroy
  redirect_to collections_path
 end

 private

 def collection_params
  params.require(:collection).permit(:title, :description)
 end
end
