module CadiMenu
  class Engine < ::Rails::Engine
    isolate_namespace CadiMenu

    initializer "cadi_menu.append_view_paths" do |app|
      app.config.paths["app/views"] << root.join("app/views").to_s
    end

    initializer "cadi_menu.load" do |app|
      CadiMenu.current_app_path ||= "company"
      CadiMenu.company_url ||= "#{Rails.env.development? ? "http://localhost:3007": ""}/company/shared_menu?source=#{CadiMenu.current_app_path}"
      CadiMenu.fallback_filepath ||= Rails.root.join("cadi_menu_fallback", "cached.json")
      CadiMenu.skip_fallback_request ||= false
    end
  end
end
