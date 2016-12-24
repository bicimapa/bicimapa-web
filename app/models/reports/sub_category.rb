class Reports::SubCategory < ActiveRecord::Base
  belongs_to :category, class_name: '::Reports::Category', foreign_key: 'category_id'
  paginates_per 5
end
