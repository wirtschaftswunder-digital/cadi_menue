require 'erb'
require 'ostruct'

module CadiMenu
  class MenuRenderer
    def initialize(template_path)
      @template_path = template_path
    end

    def render(data)
      template = File.read(@template_path)
      erb = ERB.new(template)
      context = OpenStruct.new(data)
      erb.result(context.instance_eval { binding })
    end
  end
end