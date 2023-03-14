class ThoughtsController < ApplicationController
  before_action :set_thought, only: %i[browse connect disconnect show]

  # shows cards that are not ourself with our connections to them
  def browse
    @thoughts = current_user.thoughts.where.not(id: @thought.id)
  end

  def index
    @thoughts = current_user.thoughts

    if params[:query].present?
      @thoughts = current_user.thoughts.search(params[:query])
    end
    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "list-thought", locals: { thoughts: @thoughts }, formats: [:html] }
    end
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
    if params[:commit] == 'Save'
      redirect_to thought_path(@thought)
    elsif
    params[:commit] == 'Save and Connect'
    redirect_to browse_thoughts_path(@thought)
    end
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

  # Used in the post requests to redirect on connect
  def connect
    set_selected_thought
    add_collection
    # @selected_thought.collection = Collection.create
    # @thought.collection = @selected_thought.collection
    @selected_thought.save
    @thought.save
    return unless @thought.connect(@selected_thought.id)

    respond_to do |format|
      format.html { redirect_to thought_path(@selected_thought) }
      format.js
    end
  end

  # Used in the post requests to redirect on disconnect
  def disconnect
    set_selected_thought
    return unless @thought.disconnect(@selected_thought.id)

    respond_to do |format|
      @selected_thought.collection = nil
      @selected_thought.save
      format.html { redirect_to thought_path(@selected_thought) }
      format.js { render action: :disconnect }
      # raise
    end
  end

  # I THINK ITS TO DO WITH THIS, NEED IT TO START AS NIL SO ITS EASY TO SWITCH BACK TO
  # WITHOUT A COLLECTION
  # COULD SOLVE WITH A COLLECTION AT 1 THAT HAS EVERYTHING AUTOMATICALLY ON IT?
  # HOW TO FIND THE ORIGINAL THE COLLECTION ID?
  # SOMETHING TO DO WITH CONNECCTIONS?
  def add_collection
    set_selected_thought
    if @thought.collection.nil?
      @thought.collection = Collection.create
      @selected_thought.collection = @thought.collection
    else
      @selected_thought.collection = @thought.collection
    end
  end

  private

  def set_thought
    @thought = Thought.find(params[:id])
    return if @thought.user == current_user
  end

  def set_selected_thought
    @selected_thought = Thought.find(params[:selected_id])
  end

  def thought_params
    params.require(:thought).permit(:title, :content)
  end
end
