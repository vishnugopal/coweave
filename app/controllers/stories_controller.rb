class StoriesController < ApplicationController
  before_action :set_story, only: [ :edit, :update ]

  def index
    @stories = Story.all
  end

  def edit
  end

  def update
    if @story.update(story_params)
      respond_to do |format|
        format.html do
          if params[:commit] == "Play"
            @playthrough = @story.playthroughs.create
            @playthrough.create_initial_developer_prompt
            GetAiResponseJob.perform_later @playthrough.id
            redirect_to playthrough_path(@playthrough)
          else
            redirect_to edit_story_path(@story), notice: "Story was successfully updated."
          end
        end
      end
    else
      render :edit
    end
  end

  private
  def set_story
    @story = Story.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:title, :text)
  end
end
