class FilesController < ApplicationController

  attr_reader :obj

  def destroy
    file_as = ActiveStorage::Attachment.find(params[:id])
    @obj = file_as.record
    if current_user.author?(obj)
      obj.files.find(file_as.id).purge
    end

    obj.reload
  end

end