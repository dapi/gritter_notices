module GritterNotices
  module RSpecMatcher
    def have_gritter_notice(text=nil)
      HaveGritterNotice.new(text)
    end

    class HaveGritterNotice
      def initialize(text)
        @text = text
      end

      def description
        "send gritter notice '#{@text}' to '#{@model}"
      end

      def failure_text_for_should
        "#{@model.class} should have gritter_notice with text '#{@text}'"
      end

      def failure_text_for_should_not
        "#{@model.class} should not have an gritter_notice with text '#{@text}'"
      end

      # def from(value)
      #   @from = value
      #   self
      # end

      # def to(value)
      #   @to = value
      #   self
      # end

      def matches?(model)
        @model = model
        not model.gritter_notices.select { |g| !@text or g.text == @text or g.options[:gritter_key] == @text }.empty?
      end
    end
  end
end
