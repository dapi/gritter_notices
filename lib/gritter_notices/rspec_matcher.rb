module GritterNotices
  module RSpecMatcher
    def have_gritter_notice(message=nil)
      HaveGritterNotice.new(message)
    end

    class HaveGritterNotice
      def initialize(message)
        @message = message
      end

      def description
        "send gritter notice '#{@message}' to '#{@model}"
      end

      def failure_message_for_should
        "#{@model.class} should have gritter_notice with message '#{@message}'"
      end

      def failure_message_for_should_not
        "#{@model.class} should not have an gritter_notice with message '#{@message}'"
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
        not model.gritter_notices.select { |g| !@message or g.message == @message or g.options[:gritter_message_key] == @message }.empty?
      end
    end
  end
end
