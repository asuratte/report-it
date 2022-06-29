require "test_helper"

class SubcategoryTest < ActiveSupport::TestCase
  setup do 
    @category1 = categories(:one)
    @category2 = categories(:two)
    @subcategory1 = subcategories(:one)
    @subcategory2 = subcategories(:two)
    @subcategory3 = subcategories(:three)
    @subcategory4 = subcategories(:four)
  end

  test "Should get three subcategories when getting all active subcategories" do 
    subcategories = [@subcategory1, @subcategory2, @subcategory4]
    assert_equal "Pothole complaint", @subcategory1.name
    assert_equal "Road hazard complaint", @subcategory2.name
    assert_equal "Grass length complaint", @subcategory4.name
    assert_equal 3, Subcategory.get_active_subcategories.count
    assert_equal subcategories, Subcategory.get_active_subcategories
  end

  test "Should get 'Pothole complaint' and 'Road hazard complaint' but not 'General road complaint' when getting subcategories by category 'Transportation and streets'" do 
    subcategories = [@subcategory1, @subcategory2]
    assert_equal "Transportation and streets", @category1.name
    assert_equal "Pothole complaint", @subcategory1.name
    assert_equal "Road hazard complaint", @subcategory2.name
    assert_equal @subcategory3.name, "General road complaint"
    assert_equal 2, Subcategory.get_active_subcategories_by_category(@category1).count
    assert_equal subcategories, Subcategory.get_active_subcategories_by_category(@category1)
  end

  test "Should get empty array when getting subcategories by category that does not have any subcategories" do 
    assert_equal [], Subcategory.get_active_subcategories_by_category(@category2)
    assert_equal 0, Subcategory.get_active_subcategories_by_category(@category2).count
  end

end
