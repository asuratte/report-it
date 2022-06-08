require "test_helper"

class ReportTest < ActiveSupport::TestCase
  test "report attributes cannot be empty" do
    report = Report.new
    assert report.invalid?
    assert report.errors[:city].any?
    assert report.errors[:state].any?
    assert report.errors[:zip].any?
    assert report.errors[:description].any?
    assert report.errors[:category].any?
    assert report.errors[:subcategory].any?
  end
end
