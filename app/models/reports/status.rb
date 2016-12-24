class Reports::Status < ActiveRecord::Base
    validates :code, :label, :fa_icon, presence: true
    validates :code, uniqueness: true
    validates :code, length: { is: 3 }
    validates :code, format: { with: /[A-Z]{3}/, message: I18n.t(:only_uppercase_letters)}
    validates :fa_icon, format: { with: /fa-[a-z-]+/, message: I18n.t(:must_be_a_valid_fontawesome_identifier)}

    paginates_per 5
end
