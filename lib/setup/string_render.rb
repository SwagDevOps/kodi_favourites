# frozen_string_literal: true

require_relative('../setup')

# Evaluable strings.
class Setup::StringRender
  def initialize(&renderable)
    self.tap do
      (raise ArgumentError, 'Proc required' unless renderable.is_a?(Proc)).then do
        @renderable = renderable
      end
    end.freeze
  end

  # @return [String]
  def to_s
    renderable.call.to_s
  end

  alias to_str to_s

  protected

  # @return [Proc]
  attr_reader :renderable
end
