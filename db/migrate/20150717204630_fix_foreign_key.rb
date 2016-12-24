class FixForeignKey < ActiveRecord::Migration
  def up
    change_column :reports_states, :status_code, :string
    update "update reports_states set status_code = (select code from reports_statuses where id = status_code::integer)"
  end

  def down
    update "update reports_states set status_code = (select id from reports_statuses where code = status_code)"
    change_column :reports_states, :status_code, 'integer USING (status_code::integer)'
  end
end
