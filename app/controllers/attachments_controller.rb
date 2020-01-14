class AttachmentsController < ApplicationController

  def delete_files
  	@file = ActiveStorage::Attachment.find(params[:id])
    @file.purge
    redirect_back(fallback_location: question_path)
  end 	
end
