require "test_helper"

class ReportTest < ActiveSupport::TestCase

  setup do
    @report = reports(:one)
    @user = users(:two)
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

  test "report is not valid if attributes are over maximum characters allowed" do
    assert @report.valid?
    @report.address1 = "a" * 51
    @report.address2 = "a" * 51
    @report.city = "a" * 51
    @report.state = "a" * 51
    @report.description = "a" * 1001
    assert @report.invalid?
    assert @report.errors[:address1].any?
    assert @report.errors[:address2].any?
    assert @report.errors[:city].any?
    assert @report.errors[:state].any?
    assert @report.errors[:description].any?
  end

end
