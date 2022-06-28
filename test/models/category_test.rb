require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  setup do 
    @category1 = categories(:one)
    @category2 = categories(:two)
  end

  test "Should get 'Transportation and streets' and 'Animals' but not 'Sidewalks' when getting active categories" do 
    categories = [@category1, @category2]
    assert_equal @category1.name, "Transportation and streets"
    assert_equal @category2.name, "Animals"
    assert_equal Category.get_active_categories, categories
  end

end
