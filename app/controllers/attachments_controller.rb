class AttachmentsController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    authorize! :destroy, @file

    @file.destroy
    redirect_back(fallback_location: question_path)
  end
end
