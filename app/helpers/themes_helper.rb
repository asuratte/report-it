module ThemesHelper
  def themes
    @themes = [
      { "name" => "Theme 1", "description" => "Default - Orange and Gray", "image" => "theme1_palette.png" },
      { "name" => "Theme 2", "description" => "Teal and Burgundy", "image" => "theme2_palette.png" },
      { "name" => "Theme 3", "description" => "Burgundy and Green", "image" => "theme3_palette.png" }
    ]
  end

  def get_description_by_name(name)
    @item = themes.find {|theme| theme["name"] == name }
    @item["description"]
  end

  def get_image_by_name(name)
    @item = themes.find {|theme| theme["name"] == name }
    @item["image"]
  end
end
