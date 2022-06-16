require "test_helper"

class ReportTest < ActiveSupport::TestCase

  setup do
    @report = reports(:one)
  end

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

  test "report should not be created if attributes are over maximum characters allowed" do
    report = Report.new
    report.address1 = "a" * 51
    report.address2 = "b" * 51
    report.city = "c" * 51
    report.state = "d" * 51
    report.zip = @report.zip
    report.description = "a" * 1001
    report.category = @report.category
    report.subcategory = @report.subcategory
    assert report.invalid?
    assert report.errors[:address1].any?
    assert report.errors[:address2].any?
    assert report.errors[:city].any?
    assert report.errors[:state].any?
    assert report.errors[:description].any?
  end

  test "report should not be created if zip has invalid format" do
    report = Report.new
    report.address1 = @report.address1
    report.address2 = @report.address2
    report.city = @report.city
    report.state = @report.state
    report.zip = 1234
    report.description = @report.description
    report.category = @report.category
    report.subcategory = @report.subcategory
    assert report.invalid?
    assert report.errors[:zip].any?
    report.zip = "123456"
    assert report.invalid?
    assert report.errors[:zip].any?
  end

  test "report should be created if fields pass validation and required fields present" do
    report = Report.new
    report.address1 = "123 Main Street"
    report.address2 = "Apt 1"
    report.city = "Boston"
    report.state = "Massachusetts"
    report.zip = 12345
    report.description = @report.description
    report.category = @report.category
    report.subcategory = @report.subcategory
    report.user = users(:one)
    assert report.valid?
  end

end
