# frozen_string_literal: true

module Setup
  ::File.realpath(__FILE__).gsub(/\.rb$/, '').tap do |path|
    {
      App: :app,
      ArgvLoader: :argv_loader,
      Git: :git,
      StringRender: :string_render,
    }.each { |k, v| autoload(k, "#{path}/#{v}") }
  end

  LIB_REPO = 'https://github.com/SwagDevOps/kodi_fav_gen.git'
  VCS_QUIET = StringRender.new { ::Setup.env(:vcs_quiet, 'false') }
  UPDATE_BRANCH = StringRender.new { ::Setup.env(:update_branch, 'master') }
  UPGRADE_BRANCH = StringRender.new { ::Setup.env(:upgrade_branch, 'master') }
  UPGRADE_PATH = StringRender.new do
    Pathname.new(self::LIB_REPO).basename('.git').to_s.then do |lib_name|
      Pathname.new('vendor/setup').join(lib_name).to_s
    end
  end

  class << self
    def call(*args)
      ::Setup::App.call(*args, env_prefix: self::ENV_PREFIX)
    end

    # @param [String, Symbol] name
    # @param [String, nil] default
    def env(name, default = nil)
      "#{::Setup::ENV_PREFIX}#{name.to_s.upcase}".then do |key|
        if default and !default.to_s.empty? and ::ENV[key].to_s.empty?
          ::ENV[key] = default.to_s
        end

        ::ENV[key]
      end
    end
  end

  private

  # @api private
  ENV_PREFIX = 'KODI_FAVGEN__'
end
