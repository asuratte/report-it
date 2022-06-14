require "application_system_test_case"

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:one)
    @user = users(:two)
  end

  test "visiting the index" do
    visit reports_url
    assert_selector "h1", text: "Reports"
  end

  test "creating a Report" do
    visit reports_url
    click_on "New Report"

    fill_in "Address1", with: @report.address1
    fill_in "Address2", with: @report.address2
    fill_in "Category", with: @report.category
    fill_in "City", with: @report.city
    fill_in "Description", with: @report.description
    fill_in "Severity", with: @report.severity
    fill_in "State", with: @report.state
    fill_in "Status", with: @report.status
    fill_in "Subcategory", with: @report.subcategory
    fill_in "User", with: @report.user_id
    fill_in "Zip", with: @report.zip
    click_on "Create Report"

    assert_text "Report was successfully created"
    click_on "Back"
  end

  test "updating a Report" do
    visit reports_url
    click_on "Edit", match: :first

    fill_in "Address1", with: @report.address1
    fill_in "Address2", with: @report.address2
    fill_in "Category", with: @report.category
    fill_in "City", with: @report.city
    fill_in "Description", with: @report.description
    fill_in "Severity", with: @report.severity
    fill_in "State", with: @report.state
    fill_in "Status", with: @report.status
    fill_in "Subcategory", with: @report.subcategory
    fill_in "User", with: @report.user_id
    fill_in "Zip", with: @report.zip
    click_on "Update Report"

    assert_text "Report was successfully updated"
    click_on "Back"
  end

  test "destroying a Report" do
    visit reports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Report was successfully destroyed"
  end
end
