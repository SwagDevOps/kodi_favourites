# frozen_string_literal: true

require_relative('../setup')

# Load gievn arguments to env.
class Setup::ArgvLoader
  class << self
    # @param [Array<String>] argv
    def call(argv)
      self.new(argv).call
    end
  end

  # @param [Array<String>] argv
  # @param [String, nil] env_prefix
  def initialize(argv, env_prefix: nil)
    self.tap do
      @items = argv.dup.freeze
      @env_prefix = env_prefix
    end.freeze
  end

  def call
    items.each do |v|
      /^([a-z A-Z]+([a-z A-Z _ \-]*))=(.*)$/.match(v).to_a.then do |match|
        [match[1], match[3]].map(&:to_s).then do |parts|
          next if parts.include?('')

          ::ENV[env_key(parts[0])] = parts[1]
        end
      end
    end
  end

  protected

  # @return [Array<String>]
  attr_reader :items

  # @return [String, nil]
  attr_reader :env_prefix

  # @param [String] name
  #
  # @return [String]
  def env_key(name)
    name.upcase.tr('-', '_').then { "#{env_prefix}#{_1}" }
  end
end
