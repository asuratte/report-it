require "test_helper"

class ReportTest < ActiveSupport::TestCase

  setup do
    @report1 = reports(:one)
    @report2 = reports(:two)
    @report3 = reports(:three)
    @report4 = reports(:four)
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
    report.zip = @report1.zip
    report.description = "a" * 1001
    report.category = @report1.category
    report.subcategory = @report1.subcategory
    assert report.invalid?
    assert report.errors[:address1].any?
    assert report.errors[:address2].any?
    assert report.errors[:city].any?
    assert report.errors[:state].any?
    assert report.errors[:description].any?
  end

  test "report should not be created if zip has invalid format" do
    report = Report.new
    report.address1 = @report1.address1
    report.address2 = @report1.address2
    report.city = @report1.city
    report.state = @report1.state
    report.zip = 1234
    report.description = @report1.description
    report.category = @report1.category
    report.subcategory = @report1.subcategory
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
    report.description = @report1.description
    report.category = @report1.category
    report.subcategory = @report1.subcategory
    report.user = users(:one)
    assert report.valid?
  end

  test "should return true for report1 is_active?" do
    assert @report1.is_active?
    assert_equal @report1.active_status, "active"
  end

  test "should return false for report2 with active_status 'spam' is_active?" do
    assert !@report2.is_active?
    assert_equal @report2.active_status, "spam"
  end

  test "should return false for report3 with active_status 'abuse' is_active?" do
    assert !@report3.is_active?
    assert_equal @report3.active_status, "abuse"
  end

  test "should return false for report4 with active_status 'outside_area' is_active?" do
    assert !@report4.is_active?
    assert_equal @report4.active_status, "outside_area"
  end

  test "report should be created with valid image content type" do
    report = Report.new
    report.address1 = "123 Main Street"
    report.address2 = "Apt 1"
    report.city = "Boston"
    report.state = "Massachusetts"
    report.zip = 12345
    report.description = @report1.description
    report.category = @report1.category
    report.subcategory = @report1.subcategory
    report.user = users(:one)
    report.image.attach(
      io: File.open(Rails.root.join('test', 'fixtures', 'files', 'testimage.png')),
      filename: 'testimage.png',
      content_type: 'image/png'
    )
    assert report.image.attached?
    assert report.valid?
  end

  test "report should not be created with invalid image content type" do
    report = Report.new
    report.address1 = "123 Main Street"
    report.address2 = "Apt 1"
    report.city = "Boston"
    report.state = "Massachusetts"
    report.zip = 12345
    report.description = @report1.description
    report.category = @report1.category
    report.subcategory = @report1.subcategory
    report.user = users(:one)
    report.image.attach(
      io: File.open(Rails.root.join('test', 'fixtures', 'files', 'testimage2.gif')),
      filename: 'testimage2.gif',
      content_type: 'image/gif'
    )
    assert report.invalid?
    assert report.errors[:image].any?
    assert_equal ["has an invalid content type", "must be between 1 KB and 5 MB"], report.errors[:image]
  end

  test "search returns a single report" do
    report = Report.search("Incident No.", @report1.id.to_s)
    assert_equal 1, report.count
  end

  test "search returns multiple reports" do
    report = Report.search("State", "GA")
    assert report.count > 1
  end

  test "search returns no report" do
    report = Report.search("State", "HI")
    assert_equal 0, report.count
  end

  test "search returns all reports if no search parameters specified" do
    report = Report.search("", "")
    assert_equal 5, report.count
  end

  test "search finds reports by incident number" do
    report = Report.search("Incident No.", @report1.id.to_s)
    assert_equal 1, report.count
    assert_equal "No trash pickup on Monday", report.first.description
  end

  test "search finds no reports for invalid incident numbers" do
    report = Report.search("Incident No.", "abc")
    assert_equal 0, report.count
    report = Report.search("Incident No.", "1.5")
    assert_equal 0, report.count
  end

  test "search finds reports by address" do
    report = Report.search("Address", @report1.address1)
    assert_equal 1, report.count
    assert_equal "No trash pickup on Monday", report.first.description
  end

  test "search finds reports by partial address" do
    report = Report.search("Address", "Main")
    assert_equal 1, report.count
    assert_equal "No trash pickup on Monday", report.first.description
  end

  test "search finds reports by city" do
    report = Report.search("City", @report1.city)
    assert_equal 3, report.count
    assert_equal "No trash pickup on Monday", report.first.description
    assert_equal "The lights are out at the intersection of East and West Ave", report.last.description
  end

  test "search finds reports by state" do
    report = Report.search("State", @report1.state)
    assert_equal 5, report.count
  end

  test "search finds reports by zip" do
    report = Report.search("Zip", @report1.zip)
    assert_equal 2, report.count
    assert_equal "No trash pickup on Monday", report.first.description
    assert_equal "The lights are out at the intersection of East and West Ave", report.last.description
  end

  test "search finds reports by description" do
    report = Report.search("Description", @report1.description)
    assert_equal 1, report.count
    assert_equal 1, report.first.id
  end

  test "search finds reports by partial description" do
    report = Report.search("Description", "lights are out")
    assert_equal 2, report.count
    assert_equal 2, report.first.id
    assert_equal 3, report.last.id
  end

  test "search finds reports by category" do
    report = Report.search("Category", "Trash, Recycling, and Pickup")
    assert_equal 2, report.count
    assert_equal 1, report.first.id
    assert_equal 5, report.last.id
  end

  test "search finds reports by subcategory" do
    report = Report.search("Category", "Sewer complaint")
    assert_equal 1, report.count
    assert_equal 4, report.first.id
  end

end
