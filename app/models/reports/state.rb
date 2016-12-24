class Reports::State < ActiveRecord::Base
  belongs_to :report, class_name: '::Reports::Report', foreign_key: 'report_id'
  belongs_to :status, class_name: '::Reports::Status', primary_key: 'code', foreign_key: 'status_code'
end
