module GritterNotices::ActiveRecord

  ValidMethods = Hash[*GritterNotices::KEYS.map { |key| ["gritter_notice_#{key}", key] }.flatten]

  # :level => [:success, :warning, :notice, :error, :progress]
  def has_gritter_notices
    has_many :gritter_notices, :as => :owner, :dependent => :delete_all
    include InstanceMethods
  end

  module InstanceMethods

    #
    # Examples:
    #
    # notice :text=>'asdsad', :image=>:notice
    # notice 'message', :level=>:success
    #
    def gritter_notice *args
      options = args.extract_options!
      text = args.first || options[:text]
      options = {:scope=>:gritter_notices}.merge options
      if text.is_a? Symbol
        options[:gritter_key] = text
        options[:level] = text unless options[:level]
        text = options[:text] || I18n::translate(text, options)
      end
      options[:level]=:notice unless options[:level]
      gritter_notices.create! :text=>text, :options=>options
    end

    alias_method :notice, :gritter_notice

    #
    # notice_success
    # notice_error
    # notice_warning
    # notice_progress
    # notice_notice    - default. An alias for `notice`
    #
    def method_missing(method_name, *args, &block)
      if level = ValidMethods[method_name.to_s] or level = ValidMethods["gritter_#{method_name}"]
        options = args.extract_options!
        options[:level] = level
        args << options
        gritter_notice *args
      else
        super(method_name, *args, &block)
      end
    end
  end
end
