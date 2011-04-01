# -*- coding: utf-8 -*-
require 'gritter'
module GritterNotices::ViewHelpers

  include Gritter::Helpers

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
    gritters = []

    # Собираем flash-сообщения
    add_flashes_to_gritters( gritters, flash, titles )
    add_notices_to_gitters( gritters,
      current_user.gritter_notices.fresh, titles) if defined?(current_user) and current_user.respond_to?(:gritter_notices)

    js(gritters).html_safe unless gritters.empty?
  end

  def add_notices_to_gitters(gritters, list, titles)
    list.each do |notice|
      options = notice.options
      gritter_key = GRITTER_CONVERT_KEYS[options[:level]] || GRITTER_CONVERT_KEYS[:other] || options[:level]
      options[:title] = titles[gritter_key] || options[:level].to_s  unless options[:title]
      options[:image] = gritter_key unless options[:image]
      gritters << add_gritter(notice.text, options)
      notice.mark_as_delivered
    end
  end

  def add_flashes_to_gritters(gritters, list, titles)
    list.each_pair do |key, message_array|
      next unless message_array
      message_array = [message_array] unless message_array.is_a? Array
      message_array.flatten.each { |message|
        key = key.to_sym
        # Превращаем системные флешки в гритеровские
        gritter_key = GRITTER_CONVERT_KEYS[key] || GRITTER_CONVERT_KEYS[:other] || key
        title = titles[gritter_key] || key.to_s
        gritters << add_gritter(message, :image => gritter_key, :title => title)
      }
    end

  end

  def move_gritter_notices_to_flashes
    return unless current_user
    current_user.gritter_notices.fresh.each do |notice|
      append_flash_message notice.level, notice.text
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
