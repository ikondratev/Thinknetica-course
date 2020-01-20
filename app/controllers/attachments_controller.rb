class AttachmentsController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    if current_user.is_author_of?(@file.record)
      @file.destroy
      redirect_back(fallback_location: question_path)
    end
  end
end
