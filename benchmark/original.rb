# frozen_string_literal: true

# Original implementation for benchmarking comparison
# This was the implementation before performance optimizations
module ClsxOriginal
  def clsx_original(*args)
    result = clsx_args_processor_original(*args)
    result.uniq!
    result.join(' ').presence
  end

  private

  def clsx_args_processor_original(*args)
    result = []
    complex_keys = []

    args.flatten!
    args.each do |arg|
      next if arg.blank? || arg.is_a?(TrueClass) || arg.is_a?(Proc)
      next result << arg.to_s unless arg.is_a?(Hash)

      arg.each { |key, value| complex_keys << key if value }
    end

    return result if complex_keys.empty?

    result + clsx_args_processor_original(*complex_keys)
  end
end
