require "json"

class CollectionsController < ApplicationController
  def index
    @collections = current_user.collections
  end

  def show
    @collection = current_user.collections.find(params[:id])
    @thoughts = Thought.where(collection_id: @collection.id)

    @data = @collection.thoughts.map do |thought|
      if thought.parent.nil?
        {
          "name": thought.title,
          "parent": "null",
          "url":"http://www.google.co.uk",
          "content": thought.content
        }
      else
        {
          "name": thought.title,
          "parent": thought.parent.title,
          "url":"http://www.google.co.uk",
          "content": thought.content
        }
      end
    end

    @stringified_data = @data.to_json
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
