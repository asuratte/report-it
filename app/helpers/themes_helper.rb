module ThemesHelper
  def themes
    @themes = [
      { "id" => 1, "name" => "Theme 1", "description" => "Default - Orange and Gray", "image" => "theme1_palette.png" },
      { "id" => 2, "name" => "Theme 2", "description" => "Teal and Burgundy", "image" => "theme2_palette.png" },
      { "id" => 3, "name" => "Theme 3", "description" => "Burgundy and Green", "image" => "theme3_palette.png" }
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

  def get_current_theme
    @current_theme = Theme.first.name
  end

  def get_id_by_name(name)
    @item = themes.find {|theme| theme["name"] == name }
    @item["id"]
  end
end
