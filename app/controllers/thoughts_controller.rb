class ThoughtsController < ApplicationController
  before_action :set_thought, only: [:browse, :connect, :disconnect, :show]

  #shows cards that are not ourself with our connections to them
  def browse
    @thoughts = Thought.where.not(id: @thought.id)
  end

  def index
    @thoughts = Thought.all
  end

  def new
    @thought = Thought.new
  end

  def create

  end

  def show
  end

  #Used in the post requests to redirect on connect
  def connect
    set_selected_thought
    if @thought.connect(@selected_thought.id)
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  #Used in the post requests to redirect on disconnect
  def disconnect
    set_selected_thought
    if @thought.disconnect(@selected_thought.id)
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render action: :connect }
      end
    end
  end

  private

  def set_thought
    @thought = Thought.find(params[:id])
  end

  def set_selected_thought
    @selected_thought = Thought.find(params[:selected_id])
  end
end
