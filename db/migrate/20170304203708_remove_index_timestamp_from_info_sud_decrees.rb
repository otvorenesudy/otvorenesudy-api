class RemoveIndexTimestampFromInfoSudDecrees < ActiveRecord::Migration[5.0]
  def change
    InfoSud::Decree.update_all('data = data - \'index_timestamp\'')
  end
end
