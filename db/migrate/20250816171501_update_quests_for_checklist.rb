class UpdateQuestsForChecklist < ActiveRecord::Migration[8.0]
  def up
    # 1) ให้มี content ก่อนเสมอ
    if column_exists?(:quests, :content)
      # ok
    elsif column_exists?(:quests, :title)
      rename_column :quests, :title, :content
    else
      add_column :quests, :content, :text
    end

    # 2) บังคับชนิดและ not null
    change_column :quests, :content, :text
    change_column_null :quests, :content, false

    # 3) เพิ่มช่องสถานะ/กำหนดส่ง
    add_column :quests, :done, :boolean, null: false, default: false unless column_exists?(:quests, :done)
    add_column :quests, :due_date, :date unless column_exists?(:quests, :due_date)

    # 4) index (กันซ้ำได้)
    add_index :quests, :done, if_not_exists: true
    add_index :quests, :due_date, if_not_exists: true
  end

  def down
    remove_index :quests, :due_date if index_exists?(:quests, :due_date)
    remove_index :quests, :done if index_exists?(:quests, :done)

    remove_column :quests, :due_date if column_exists?(:quests, :due_date)
    remove_column :quests, :done if column_exists?(:quests, :done)

    # ผ่อนคลาย not null
    change_column_null :quests, :content, true if column_exists?(:quests, :content)

    # ถ้าอยากย้อนชื่อกลับ (ไม่บังคับ)
    if column_exists?(:quests, :content) && !column_exists?(:quests, :title)
      rename_column :quests, :content, :title
      change_column :quests, :title, :string
    end
  end
end
