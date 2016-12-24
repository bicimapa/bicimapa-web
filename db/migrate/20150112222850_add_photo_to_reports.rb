class AddPhotoToReports < ActiveRecord::Migration
  def self.up
    add_attachment :reports_reports, :photo
  end

  def self.down
    remove_attachment :reports_reports, :photo
  end
end
