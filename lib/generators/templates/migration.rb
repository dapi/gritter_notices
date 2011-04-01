class CreateGritterNoticesTable < ActiveRecord::Migration
  def self.up
    create_table :gritter_notices, :force => true do |t|
      t.integer  :owner_id,                            :null => false
      t.string   :owner_type,                          :null => false
      t.text     :text,                                :null => false
      # t.string   :level,        :default => "notice", :null => false
      # t.string   :title
      # t.string   :image
      # t.boolean  :sticky, :default=>false, :null=>false
      t.text     :options, :null=>false
      t.datetime :delivered_at
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :gritter_notices, [:owner_id, :delivered_at]
  end

  def self.down
    drop_table :gritter_notices
  end
end
