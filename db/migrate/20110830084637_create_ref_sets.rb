class CreateRefSets < ActiveRecord::Migration
  def self.up
    create_table :ref_sets do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ref_sets
  end
end
