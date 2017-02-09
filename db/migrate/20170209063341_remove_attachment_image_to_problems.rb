class RemoveAttachmentImageToProblems < ActiveRecord::Migration[5.0]
  def change
    remove_attachment :problems, :image
  end
end
