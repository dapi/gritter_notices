# -*- coding: utf-8 -*-
module GritterNotices
  # Keys supported by gritter
  KEYS = [ :success, :warning, :notice, :error, :progress ]
end

require 'gritter_notices/active_record'
ActiveRecord::Base.send( :extend, GritterNotices::ActiveRecord )

require 'gritter_notices/view_helpers'
ActionView::Base.send( :include, GritterNotices::ViewHelpers )

require 'gritter_notices/rspec_matcher'

require 'gritter_notices/engine' if defined?(Rails)


