module DeltaControl
  module ViewHelper

    def style_tags(*files)
      capture_haml do
        files.each do |file|
          haml_tag :link, :href => url('/css/%s.css' % file.to_s), :rel => 'stylesheet'
        end
      end
    end

    def script_tags(*files)
      capture_haml do
        files.each do |file|
          haml_tag :script, :src => url('/js/%s.js' % file.to_s), :type => 'text/javascript'
        end
      end
    end

    def flash_block_for(message_type)
      return unless flash[message_type]
      capture_haml do
        haml_tag :div, :class => [ 'alert', 'fade', 'in', message_type ] do
          haml_tag :a, :class => :close, :href => '#' do
            haml_concat 'x'
          end
          haml_concat flash[message_type]
        end
      end
    end

    def flash
      @_flash ||= {}
    end

    def current_url_title
      return @title if !@title.nil?
      last_url_segment = request.path_info.split('/').last
      last_url_segment.nil? ? 'NoTitleFixMe' : last_url_segment.capitalize
    end

  end
end
