class ThoughtsController < ApplicationController
  before_action :set_thought, only: [:browse, :connect, :disconnect, :show]

  def browse
    @thoughts = Thought.where.not(id: @thought.id)
    # raise
  end

  def show
  end

  def connect
    # raise
    set_selected_thought
    if @thought.connect(@selected_thought.id)
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

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
