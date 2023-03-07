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
    if @thought.connect(params[:selected_id])
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  def disconnect
    if @thought.disconnect(params[:selected_id])
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
end
