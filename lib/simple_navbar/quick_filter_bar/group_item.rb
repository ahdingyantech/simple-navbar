module SimpleNavbar
  module QuickFilterBar
    class GroupItem
      def initialize(view, group, param_value, text:)
        @view  = view
        @group = group
        @builder = group.builder

        @param_value = param_value.to_s
        @text = text
      end

      def _get_url
        query = @view.request.fullpath.split("?")[1] || ""
        hash = SimpleNavbar::QuickFilterBar::UrlQueryString.decode(query)

        if @param_value == ""
          hash.delete @group.param_name
        else
          hash[@group.param_name] = @param_value
        end

        if hash.blank?
          @view.request.fullpath.split("?")[0]
        else
          query = SimpleNavbar::QuickFilterBar::UrlQueryString.encode(hash)
          "#{@view.request.fullpath.split("?")[0]}#{query}"
        end
      end

      def is_active?
        @view.params[@group.param_name.to_sym] == @param_value
      end

      def render
        attrs = {}
        attrs[:class] = "active" if is_active?

        @view.haml_tag :li, attrs do
          @view.haml_tag :a, @text, :href => _get_url
        end
      end

    end

  end
end
