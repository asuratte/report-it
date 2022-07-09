module SettingsHelper
    def get_homepage_heading_1
        @homepage_heading_1 = Setting.first.homepage_heading_1
    end

    def get_footer_copyright
        @footer_copyright = Setting.first.footer_copyright
    end

    def get_allow_anonymous_reports
        @allow_anonymous_reports = Setting.first.allow_anonymous_reports
    end

    def get_setting
        @setting = Setting.first
    end
end
