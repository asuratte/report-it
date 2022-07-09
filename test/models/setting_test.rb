require "test_helper"

class SettingTest < ActiveSupport::TestCase
  setup do
    @setting = settings(:one)
  end

  test "setting should be created with valid image content type" do
    setting = Setting.new
    setting.image.attach(
      io: File.open(Rails.root.join('test', 'fixtures', 'files', 'testimage.png')),
      filename: 'testimage.png',
      content_type: 'image/png'
    )
    assert setting.image.attached?
    assert setting.valid?
  end

  test "setting should not be created with invalid image content type" do
    setting = Setting.new
    setting.image.attach(
      io: File.open(Rails.root.join('test', 'fixtures', 'files', 'testimage2.gif')),
      filename: 'testimage2.gif',
      content_type: 'image/gif'
    )
    assert setting.invalid?
    assert setting.errors[:image].any?
    assert_equal ["has an invalid content type", "must be between 1 KB and 5 MB"], setting.errors[:image]
  end
end
