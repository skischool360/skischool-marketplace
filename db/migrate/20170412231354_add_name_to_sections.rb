class AddNameToSections < ActiveRecord::Migration[5.0]
  def change
  	    add_column :sections, :name, :string
  	    add_column :sections, :shift_id, :integer
  end
end
