# -*- coding: utf-8 -*-

module GritterNotices::ViewHelpers

  GRITTER_CONVERT_KEYS = { :info=>:notice, :alert=>:warning, :failure=>:error, :other=>:notice }.
    merge Hash[*GritterNotices::KEYS.map {|k| [k,k]}.flatten]


  #
  # Ключи понимаемые гриттером:
  # :success, :warning, :notice, :error, :progress
  #
  # Все возможные (системные):
  # :success, :warning, :notice, :error, :alert, :info, :failure

  def gritter_flash_messages *args
    options = args.extract_options!
    titles = gflash_titles(options)
    flashes = []

    # Собираем flash-сообщения
    flash.each_pair do |key, message_array|
      message_array = [message_array] unless message_array.is_a? Array
      message_array.flatten.each { |message|
        key = key.to_sym
        # Превращаем системные флешки в гритеровские
        gritter_key = GRITTER_CONVERT_KEYS[key] || GRITTER_CONVERT_KEYS[:other] || key
        title = titles[gritter_key] || key.to_s
        flashes << add_gritter(message, :image => gritter_key, :title => title)
      }
    end

    # Собираем gritter_notices
    current_user.gritter_notices.fresh.each do |notice|
      options = notice.options
      gritter_key = GRITTER_CONVERT_KEYS[options[:level]] || GRITTER_CONVERT_KEYS[:other] || options[:level]
      options[:title] = titles[gritter_key] || options[:level].to_s  unless options[:title]
      options[:image] = gritter_key unless options[:image]
      flashes << add_gritter(notice.message, options)
      notice.mark_as_delivered
    end if current_user and current_user.respond_to? :gritter_notices

    js(flashes).html_safe
  end

  def move_gritter_notices_to_flashes
    return unless current_user
    current_user.gritter_notices.fresh.each do |notice|
      append_flash_message notice.level, notice.message
      notice.mark_as_delivered
    end
  end

  private

  def append_flash_message(type, msg, now=false)
    f = now ? flash.now : flash
    f[type] ||= []
    f[type] << msg
  end
end
