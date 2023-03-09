class ThoughtsController < ApplicationController
  before_action :set_thought, only: [:browse, :connect, :disconnect, :show]

  #shows cards that are not ourself with our connections to them
  def browse
    @thoughts = current_user.thoughts.where.not(id: @thought.id)
  end

  def index
    @thoughts = current_user.thoughts
  end


  def show
  end

  def new
    @thought = Thought.new
  end

  def create
    @thought = Thought.new(thought_params)
    @thought.user = current_user
    # add_collection
    @thought.save

    redirect_to thought_path(@thought)
  end

  def edit
    @thought = Thought.find(params[:id])
  end

  def update
    @thought = Thought.find(params[:id])
    # add_collection
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
    # add_collection
    @selected_thought.collection = Collection.create
    @thought.collection = @selected_thought.collection
    @selected_thought.save
    @thought.save
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
        @selected_thought.collection = nil
        @selected_thought.save
        format.html { redirect_to thought_path(@selected_thought) }
        format.js { render action: :disconnect }
        # raise
      end
    end
  end

  # I THINK ITS TO DO WITH THIS, NEED IT TO START AS NIL SO ITS EASY TO SWITCH BACK TO
  # WITHOUT A COLLECTION
  # COULD SOLVE WITH A COLLECTION AT 1 THAT HAS EVERYTHING AUTOMATICALLY ON IT?
  # HOW TO FIND THE ORIGINAL THE COLLECTION ID?
  # SOMETHING TO DO WITH CONNECCTIONS?
  def add_collection
    # if @thought.parent
      @thought.collection = Collection.create
      # @thought.collection = @thought.parent.collection
    # else
    #   @thought.collection_id = nil
      # @thought.collection = Collection.create
    # end
  end

  private

  def set_thought
    @thought = Thought.find(params[:id])
    return if @thought.user = current_user
  end

  def set_selected_thought
    @selected_thought = Thought.find(params[:selected_id])
  end

  def thought_params
    params.require(:thought).permit(:title, :content)
  end
end
