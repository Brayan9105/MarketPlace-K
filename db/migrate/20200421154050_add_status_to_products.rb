class AddStatusToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :status, :integer, dafault: 2
  end
end
