module GritterNotices::ActiveRecord

  ValidMethods = Hash[*GritterNotices::KEYS.map { |key| ["notice_#{key}".to_sym, key] }.flatten]

  # :level => [:success, :warning, :notice, :error, :progress]
  def has_gritter_notices
    has_many :gritter_notices, :as => :owner, :dependent => :delete_all
    include InstanceMethods
  end

  module InstanceMethods

    #
    # Examples:
    #
    # notice :message=>'asdsad', :image=>:notice
    # notice 'message', :level=>:success
    #

    def notice *args
      options = args.extract_options!
      message = args.first || options[:message]
      options = {:scope=>:gritter_notices}.merge options
      if message.is_a? Symbol
        options[:gritter_message_key] = message
        options[:level] = message unless options[:level]
        message = I18n::translate(message, options)
      end
      options[:level]=:notice unless options[:level]
      gritter_notices.create! :message=>message, :options=>options
    end

    # notice_success
    # notice_error
    # notice_warning
    # notice_progress
    # notice_notice    - default. An alias for `notice`

    def method_missing(method_name, *args, &block)
      if level = ValidMethods[method_name]
        options = args.extract_options!
        options[:level] = level
        args << options
        notice *args
      else
        super(method_name, *args, &block)
      end
    end
  end
end
