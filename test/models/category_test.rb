require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  setup do 
    @category1 = categories(:one)
    @category2 = categories(:two)
    @category4 = categories(:four)
  end

  test "Should get three categories when getting active categories" do 
    categories = [@category1, @category2, @category4]
    assert_equal @category1.name, "Transportation and streets"
    assert_equal @category2.name, "Animals"
    assert_equal @category4.name, "Residential"
    assert_equal Category.get_active_categories, categories
  end

  test "Should not create category if name is empty" do
    category = Category.new
    category.active = @category1.active
    assert category.invalid?
    assert category.errors[:name].any?
  end

end
