require "test_helper"

class SubcategoryTest < ActiveSupport::TestCase
  setup do 
    @category1 = categories(:one)
    @category2 = categories(:two)
    @subcategory1 = subcategories(:one)
    @subcategory2 = subcategories(:two)
    @subcategory3 = subcategories(:three)
  end

  test "Should get 'Pothole complaint' and 'Road hazard complaint' but not 'General road complaint' when getting subcategories by category 'Transportation and streets'" do 
    subcategories = [@subcategory1, @subcategory2]
    assert_equal @category1.name, "Transportation and streets"
    assert_equal @subcategory1.name, "Pothole complaint"
    assert_equal @subcategory2.name, "Road hazard complaint"
    assert_equal @subcategory3.name, "General road complaint"
    assert_equal Subcategory.get_active_subcategories_by_category(@category1), subcategories
  end

  test "Should get empty array when getting subcategories by category that does not have any subcategories" do 
    assert_equal Subcategory.get_active_subcategories_by_category(@category2), []
  end

end
