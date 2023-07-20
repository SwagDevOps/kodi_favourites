# frozen_string_literal: true

require_relative('../setup')

# Main process
class Setup::App
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')

  # @param [Array<String> argv]
  # @param [String. nil] env_prefix
  def call(argv = nil, env_prefix: nil)
    ::Setup::ArgvLoader.new(argv || [], env_prefix: env_prefix).call

    # process
    self.upgrade_path.tap do |lib_dir|
      warn("#{lib_dir.exist? ? 'Upgrading' : 'Installing'} #{File.basename(lib_dir)} ...")
      fs.mkdir_p(lib_dir.dirname) unless lib_dir.exist?
      (git.call('clone', lib_repo, lib_dir.to_path) unless lib_dir.directory?).then do
        ::Dir.chdir(lib_dir.to_path) { git.update(branch: upgrade_branch, exception: true) }
      end
    end

    sleep(0.1).then do
      warn('Updating current setup ...')
      git.update(branch: update_branch, exception: true)
    end
  end

  class << self
    # @param [Array<String> argv]
    # @param [String. nil] env_prefix
    def call(argv = nil, env_prefix: nil)
      self.__send__(:new).call(argv, env_prefix: env_prefix)
    end
  end

  protected

  def initialize
    freeze
  end

  # Path where lib (``kodi_fav_gen``) is stored.
  #
  # @return [Pathname]
  def upgrade_path
    Pathname.new(::Setup::UPGRADE_PATH).expand_path
  end

  # @return [String]
  def upgrade_branch
    ::Setup::UPGRADE_BRANCH.to_s
  end

  # @return [String]
  def update_branch
    ::Setup::UPDATE_BRANCH.to_s
  end

  # @return [String]
  def lib_repo
    ::Setup::LIB_REPO
  end

  # @return [Module<FileUtils::Verbose>, Module<FileUtils>]
  def fs
    FileUtils::Verbose
  end

  # @return [Git]
  def git
    ::Setup::Git.new
  end
end
