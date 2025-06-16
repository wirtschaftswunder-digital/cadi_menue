require "cadi_menu/version"
require "cadi_menu/engine"
require "cadi_menu/fetcher"
require "cadi_menu/menu_renderer"

module CadiMenu
  class << self
    attr_accessor :current_app_path, :company_url, :fallback_filepath

    def configure
      yield self
    end

    def client_fix_urls_js
      {jsFix: ""}
    end

    def fetch_fallback
      fetched = Fetcher.fetch_or_cached()
      fetched.merge(client_fix_urls_js)
    end

    def build_accounts_dropdown_html(options)
      links = ""
      options[:anbieter_auswahl].each do |anbieter|
        is_current_anbieter = anbieter[:id] == options[:anbieter_id]
        link = "/#{options[:logout_path].split("/")[1]}/admin/users/change_anbieter?anbieter_id=#{anbieter[:id]}&id=#{options[:user_id]}&redirect=#{options[:current_path]}"
        a_tag = "<a class='ui item #{is_current_anbieter ? "current-anbieter bold-font" : "black"}' href='#{link}' #{is_current_anbieter ? "style='color: #{options[:base_color]}'" : ''}>
            <i class='fas fa-home fixed-icon'></i>#{anbieter[:name]}
        </a>"
        links << "#{a_tag}\n"
      end
      " #{links}
        <hr style='margin: 0 15px 0 15px; border-bottom-width: 0px;'>
        <div id='shared-username' class='item hint' title='Benutzerprofil Einstellungen stehen aktuell noch nicht zur Verfügung.'>
          <i class='fas fa-user-circle fixed-icon'></i>#{options[:nickname].strip}
        </div>
        <a id='logout-link' class='item' rel='nofollow' data-method='post' href='#{options[:logout_path]}'>
            <i class='fas fa-sign-out-alt fixed-icon'></i>Logout
        </a>"
    end

    ## ## Required options
    ## - current_path
    ## - nickname
    ## - user_id
    ## - base_color
    ## - anbieter_farbe
    ## - anbieter_id
    ## - anbieter_auswahl
    ## - menu_items [app_menu_items(current_user)]
    ## - logout_path
    ## - env
    def render_menu(options = {})
      ensure_valid_options(options)
      if options[:current_path].split("?")[0].end_with?("/login") || options[:current_path].split("?")[0].end_with?("/user_sessions")
        return ""
      end
      data = {
        current_path: options[:current_path],
        base_color: options[:base_color],
        anbieter_farbe: options[:anbieter_farbe],
        anbieter_id: options[:anbieter_id],
        menu_items: options[:menu_items],
        logout_path: options[:logout_path],
        env: options[:env],
        fallback_menu: fetch_fallback,
        accounts_dropdown: build_accounts_dropdown_html(options),
      }
      template_path = File.join(__dir__, 'templates', '_shared_menu_loader.erb')
      renderer = MenuRenderer.new(template_path)
      renderer.render(data)
    end

    def ensure_valid_options(options)
      errors = []
      if !(options[:current_path].present? && options[:current_path].is_a?(String))
        errors << "current_path"
      end
      if !(options[:nickname].present? && options[:nickname].is_a?(String))
        errors << "nickname"
      end
      if !(options[:anbieter_id].present? && options[:anbieter_id].is_a?(Integer))
        errors << "anbieter_id"
      end
      if !(options[:anbieter_auswahl].present? && options[:anbieter_auswahl].is_a?(Array))
        errors << "anbieter_auswahl"
      end
      if !(options[:logout_path].present? && options[:logout_path].is_a?(String))
        errors << "logout_path"
      end
      if errors.length > 0
        raise "[CadiMenu/Render]: Invalid Keys: #{errors.join(", ")}"
      end
    end
  end
end
