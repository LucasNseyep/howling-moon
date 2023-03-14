require "json"

class CollectionsController < ApplicationController
  def index
    @collections = current_user.collections.uniq

    if params[:query].present?
      @collections = current_user.collections.search_by_title_and_description(params[:query]).uniq
      # @collections = Collection.where("user IS #{current_user} AND title ILIKE ?", "#{params[:query]}")
    end
    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "list", locals: { collections: @collections }, formats: [:html] }
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

  def new
    @collection = Collection.new
    @thought = Thought.new
  end

  def create
    @collection = Collection.new(collection_params)
    @thought = Thought.new(thought_params)
    @thought.user = current_user
    @thought.collection = @collection
    @collection.save
    @thought.save

    redirect_to collections_path
    # redirect_to collection_path(@collection)
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

  def thought_params
    params.require(:thought).permit(:title, :content)
  end
end
