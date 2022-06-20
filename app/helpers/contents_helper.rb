module ContentsHelper
    def get_logo_image_path
        @logo_image_path = Content.first.logo_image_path
    end

    def get_homepage_heading_1
        @homepage_heading_1 = Content.first.homepage_heading_1
    end

    def get_footer_copyright
        @footer_copyright = Content.first.footer_copyright
    end
end
