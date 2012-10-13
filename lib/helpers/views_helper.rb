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
        haml_tag :div, :class => [ 'alert', 'fade', 'in', 'alert-'+message_type.to_s ], 'data-dismiss' => 'alert' do
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

    def cgroup(id, label='', &block)
      haml_tag :div, :class => :"control-group" do
        haml_tag :label, :class => :"control-label", :for => id do
          haml_concat label
        end
        haml_tag :div, :class => :controls do
          haml_concat(capture_haml(&block))
        end
      end
    end

    def format_status(status)
      case status
        when 200..399 then '<span class="label label-success">%i</span>' % status
        when 400..499 then '<span class="label label-warning">%i</span>' % status
        when 500..599 then '<span class="label label-important">%i</span>' % status
        else '<span class="label">%i</span>' % status
      end
    end

    def format_log_body(body)
      body.gsub('<', '&lt;').gsub('>', '&gt;')
    end

    def status_to_text(code)
      case code
      when 200; "OK"
      when 201; "Created"
      when 202; "Accepted"
      when 204; "No Content"
      when 301; "Moved Permanently"
      when 303; "See Other"
      when 400; "Bad Request"
      when 401; "Unauthorized"
      when 403; "Forbidden"
      when 404; "Not Found"
      when 405; "Method Not Allowed"
      when 406; "Not Acceptable"
      when 500; "Internal Server Error"
      when 502; "Backend Server Error"
      when 504; "Gateway Timeout"
      when 501; "Not Supported"
      else 'Unknown'
      end
    end

  end
end
