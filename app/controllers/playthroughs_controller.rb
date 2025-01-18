class PlaythroughsController < ApplicationController
  before_action :set_playthrough, only: %i[show]

  def show
  end

  def create
    @playthrough = Playthrough.create()
    respond_with(@playthrough)
  end

  private

  def set_playthrough
    @playthrough = Playthrough.find(params[:id])
  end
end
