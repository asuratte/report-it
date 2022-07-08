module SettingsHelper
    def get_logo_image_path
        @logo_image_path = Setting.first.logo_image_path
    end

    def get_homepage_heading_1
        @homepage_heading_1 = Setting.first.homepage_heading_1
    end

    def get_footer_copyright
        @footer_copyright = Setting.first.footer_copyright
    end

    def get_setting
        @setting = Setting.first
    end
end
