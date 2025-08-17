class DropBrags < ActiveRecord::Migration[8.0]
  def up
    drop_table :brags, if_exists: true
  end

  def down
    # เผื่ออยาก rollback กลับ (ไม่จำเป็นต้องมี แต่ใส่ไว้ให้ครบ)
    create_table :brags do |t|
      t.string   :title
      t.text     :content
      t.datetime :published_at
      t.timestamps
    end
  end
end
