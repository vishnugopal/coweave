class MessagesController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @message = Message.create(message_params.merge(playthrough_id: params[:playthrough_id], role: "user"))

    GetAiResponseJob.perform_later @message.playthrough_id

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
