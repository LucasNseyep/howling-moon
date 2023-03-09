require "json"

class CollectionsController < ApplicationController
  def index
    @collections = current_user.collections
  end

  def show
    @collection = current_user.collections.find(params[:id])

    @data = @collection.thoughts.map do |thought|
      if thought.parent.nil?
        { "name": thought.title, "parent": "null" }
      else
        { "name": thought.title, "parent": thought.parent.title }
      end
    end

    @stringified_data = @data.to_json
  end
end
