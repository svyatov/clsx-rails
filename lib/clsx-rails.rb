# frozen_string_literal: true

require 'active_support'
require 'action_view'

require_relative 'clsx/version'
require_relative 'clsx/helper'

# :nodoc:
module Clsx
  ActiveSupport.on_load(:action_view) { include Helper }
end
