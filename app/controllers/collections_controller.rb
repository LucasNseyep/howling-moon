require "json"

class CollectionsController < ApplicationController
  def index
    if params[:query].present?
      @collections = current_user.collections.search_by_title_and_description(params[:query]).uniq
    else
      @collections = current_user.collections.uniq
    end
  end

  def show
    @collection = current_user.collections.find(params[:id])
    @thoughts = Thought.where(collection_id: @collection.id)

    @data = @collection.thoughts.map do |thought|
      if thought.parent.nil?
        {
          name: thought.title,
          parent: "null",
          url: "http://www.howlingmoon.xyz/thoughts/#{thought.id}",
          content: thought.content
        }
      else
        {
          name: thought.title,
          parent: thought.parent.title,
          url: "http://www.howlingmoon.xyz/thoughts/#{thought.id}",
          content: thought.content
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
    @collection.thoughts.first.child_relationships.destroy_all
    @collection.destroy
    redirect_to collections_path
  end

  private

  def collection_params
    params.require(:collection).permit(:title, :description)
  end
end
