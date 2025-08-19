require "application_system_test_case"
require "securerandom"

class QuestsTest < ApplicationSystemTestCase
  setup do
    @quest = quests(:one)
  end

  test "visiting the index" do
    visit quests_url
    # UI ปัจจุบันเป็น <h2> ไม่ใช่ <h1>
    assert_selector "h2", text: "Quests"
    # มีรายการอย่างน้อยของ fixture
    assert_selector "[data-testid='quest-item-#{@quest.id}']"
  end

  test "creates a new quest from modal" do
    visit quests_url

    # เปิดโมดัลด้วยปุ่ม + (ไม่มีลิงก์ "New quest" แล้ว)
    find("[data-testid='new-quest-btn']").click
    assert_selector "dialog#new-quest-modal[open]"

    content = "Auto quest #{SecureRandom.hex(3)}"
    fill_in "quest_content", with: content
    click_on "Create"

    # รอให้รายการอัปเดตแล้วเห็นข้อความที่เพิ่งสร้าง
    assert_text content
  end

  test "toggles quest done status" do
    visit quests_url

    cb_selector = "[data-testid='quest-done-checkbox-#{@quest.id}']"
    span_selector = "[data-testid='quest-content-#{@quest.id}']"

    checkbox = find(cb_selector, visible: :all)
    initially_checked = checkbox.checked?

    # คลิกเพื่อสลับสถานะ
    checkbox.click

    # รอให้ Turbo รีเฟรชแล้วสถานะแตกต่างจากเดิม
    assert_retry do
      find(cb_selector, visible: :all).checked? != initially_checked
    end

    # สไตล์ตัวอักษรควรเปลี่ยนตามสถานะ
    if initially_checked
      # เดิม checked -> หลังคลิกควรเอาเส้นคาดออก
      assert_no_selector "#{span_selector}.line-through"
    else
      # เดิมไม่ checked -> หลังคลิกควรมีเส้นคาด
      assert_selector "#{span_selector}.line-through"
    end
  end

  test "deletes a quest" do
    visit quests_url

    item_selector = "[data-testid='quest-item-#{@quest.id}']"
    btn_selector  = "[data-testid='quest-delete-btn-#{@quest.id}']"

    # เก็บข้อความไว้เพื่อเช็คว่าหายไปจริง
    content_text = find("[data-testid='quest-content-#{@quest.id}']").text

    accept_confirm "Are you sure?" do
      find(btn_selector).click
    end

    # รายการต้องถูกลบออกจาก DOM
    assert_no_selector item_selector
    assert_no_text content_text
  end

  private

  # ตัวช่วยรอการเปลี่ยนแปลง (เพราะเช็ก checked? ตรงๆ ไม่ได้ใช้ assert_selector)
  def assert_retry(timeout: Capybara.default_max_wait_time)
    start = Time.now
    loop do
      begin
        return assert(yield)
      rescue Minitest::Assertion
        raise if Time.now - start > timeout
        sleep 0.1
      end
    end
  end
end
