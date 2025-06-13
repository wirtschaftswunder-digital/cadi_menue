require "httparty"
require "json"

module CadiMenu
  class Fetcher
    def self.fetch_or_cached
      debug = false
      puts "[CadiMenu/Debug] attempting to get fallback, #{CadiMenu.company_url}" if debug
      begin
        response = HTTParty.get(CadiMenu.company_url, timeout: 5, verify: false)
        if response.code != 200
          raise "Invalid response status: #{response.code}"
        end
        data = JSON.parse(response.body)
        if (data["html"].present? || data[:html].present?) && (data["js"].present? || data[:js].present?) && (data["css"].present? || data[:css].present?) && (data["footerHtml"].present? || data[:footerHtml].present?)
          FileUtils.mkdir_p(File.dirname(CadiMenu.fallback_filepath))
          File.write(CadiMenu.fallback_filepath.to_s, data.to_json)
          puts "[CadiMenu/Debug]: Successfully fetched Fallback Menu, keys: #{data.keys}" if debug
          return data
        else
          raise "Failed to load Fallback, invalid remote content"
        end
      rescue => e
        puts "[CadiMenu/Error]: #{e.message}"
        if File.exist?(CadiMenu.fallback_filepath.to_s)
          begin
            json = JSON.parse(File.read(CadiMenu.fallback_filepath.to_s))
            puts "[CadiMenu/Debug]: Loaded JSON from cache" if debug
            return json
          rescue
            puts "[CadiMenu/Error]: Failed to load Fallback, cache parsing failed"
            return {}
          end
        else
          puts "[CadiMenu/Error]: File #{CadiMenu.fallback_filepath.to_s} doesn't exist"
        end
        puts "[CadiMenu/Error]: No Fallback available"
        return {}
      end
    end
  end
end
