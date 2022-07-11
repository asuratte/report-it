require "application_system_test_case"

class FollowedReportsTest < ApplicationSystemTestCase
  setup do
    @followed_report = followed_reports(:one)
  end

  test "visiting the index" do
    visit followed_reports_url
    assert_selector "h1", text: "Followed Reports"
  end

  test "creating a Followed report" do
    visit followed_reports_url
    click_on "New Followed Report"

    fill_in "Report", with: @followed_report.report_id
    fill_in "User", with: @followed_report.user_id
    click_on "Create Followed report"

    assert_text "Followed report was successfully created"
    click_on "Back"
  end

  test "updating a Followed report" do
    visit followed_reports_url
    click_on "Edit", match: :first

    fill_in "Report", with: @followed_report.report_id
    fill_in "User", with: @followed_report.user_id
    click_on "Update Followed report"

    assert_text "Followed report was successfully updated"
    click_on "Back"
  end

  test "destroying a Followed report" do
    visit followed_reports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Followed report was successfully destroyed"
  end
end
