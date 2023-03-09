class ThoughtsController < ApplicationController
  before_action :set_thought, only: [:browse, :connect, :disconnect, :show]

  #shows cards that are not ourself with our connections to them
  def browse
    @thoughts = current_user.thoughts.where.not(id: @thought.id)
  end

  def index
    @user = current_user
    @thoughts = @user.thoughts
  end


  def show
  end

  def new
    @thought = Thought.new
  end

  def create
    @thought = Thought.new(thought_params)
    @thought.user = current_user
    @thought.save

    redirect_to thought_path(@thought)
  end

  def edit
    @thought = Thought.find(params[:id])
  end

  def update
    @thought = Thought.find(params[:id])
    @thought.update(thought_params)
    redirect_to thought_path(@thought)
  end

  def destroy
    @thought = Thought.find(params[:id])
    @thought.destroy
    redirect_to thoughts_path status: :see_other
  end

  #Used in the post requests to redirect on connect
  def connect
    set_selected_thought
    if @thought.connect(@selected_thought.id)
      respond_to do |format|
        format.html { redirect_to thought_path(@selected_thought) }
        format.js
      end
    end
  end

  #Used in the post requests to redirect on disconnect
  def disconnect
    set_selected_thought
    if @thought.disconnect(@selected_thought.id)
      respond_to do |format|
        format.html { redirect_to thought_path(@selected_thought) }
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

  def thought_params
    params.require(:thought).permit(:title, :content)
  end
end
