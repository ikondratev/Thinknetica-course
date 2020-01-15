class AttachmentsController < ApplicationController
  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    if current_user == file.record.user
      file.purge
      redirect_back(fallback_location: question_path)
    end
  end
end
