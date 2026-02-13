# frozen_string_literal: true

require 'clsx'
require 'active_support'
require 'action_view'

require_relative 'clsx/rails/version'

# :nodoc:
module Clsx
  module Rails; end # :nodoc:
  ActiveSupport.on_load(:action_view) { include Clsx::Helper }
end
