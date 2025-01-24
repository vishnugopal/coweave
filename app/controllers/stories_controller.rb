class StoriesController < ApplicationController
  before_action :set_story, only: [ :play, :edit, :update ]

  def index
    @stories = Story.all
  end

  def edit
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
