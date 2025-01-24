class StoriesController < ApplicationController
  before_action :set_story, only: [ :play, :edit, :update, :destroy ]

  def index
    @stories = Story.all
  end

  def new
    @story = Story.new
  end

  def edit
  end

  def destroy
    @story.destroy
    redirect_to stories_url, notice: "Story was successfully destroyed"
  end

  def create
    @story = Story.new(story_params)
    if @story.save
      redirect_to edit_story_path(@story), notice: "Story was successfully created."
    else
      render :new
    end
  end

  def update
    if @story.update(story_params)
      respond_to do |format|
        format.html do
          redirect_to edit_story_path(@story), notice: "Story was successfully updated."
        end
      end
    else
      render :edit
    end
  end

  def play
    play_params = params.require(:id)
    if params[:story]
      play_params = story_params
    end

    # Save and play!
    if params[:story]
      unless @story.update(play_params)
        return render :edit
      end
    end

    @playthrough = @story.playthroughs.create
    @playthrough.create_initial_developer_prompt
    GetAiResponseJob.perform_later @playthrough.id
    redirect_to playthrough_path(@playthrough)
  end

  private
  def set_story
    id = params.expect(:id)
    @story = Story.find(id)
  end

  def story_params
    params.expect(story: [ :title, :text ])
  end
end
