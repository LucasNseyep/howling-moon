require "json"

class CollectionsController < ApplicationController
  def index
    @collections = current_user.collections
  end

  def show
    @collection = current_user.collections.find(params[:id])

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
end
