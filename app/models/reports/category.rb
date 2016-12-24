class Reports::Category < ActiveRecord::Base
  has_many :sub_categories, class_name: '::Reports::SubCategory', foreign_key: 'category_id'
  paginates_per 5
end
