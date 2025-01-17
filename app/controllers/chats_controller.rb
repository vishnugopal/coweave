class ChatsController < ApplicationController
  before_action :set_chat, only: %i[show]

  def show
  end

  def create
    @chat = Chat.create()
    respond_with(@chat)
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end
end
