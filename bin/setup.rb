#!/usr/bin/env ruby
# frozen_string_literal: true

# Constants
ENV_PREFIX = 'KODI_FAVGEN_'
CODE_REPO = 'https://github.com/SwagDevOps/kodi_fav_gen.git'
CODE_BRANCH = (ENV["#{ENV_PREFIX}_CODE_BRANCH"] ||= 'master').freeze
FAVS_REPO = 'https://github.com/SwagDevOps/kodi_favourites.git'
FAVS_BRANCH = (ENV["#{ENV_PREFIX}_FAVS_BRANCH"] ||= 'master').freeze

# Dependencies
autoload(:Pathname, 'pathname')
autoload(:FileUtils, 'fileutils')

# Main process
class App
  def call
    Pathname.new(__FILE__).realpath.dirname.join('..').realpath.then do |path|
      Dir.chdir(path) do
        # process
        Pathname.new('ruby').expand_path.join(lib_name).tap do |lib_dir|
          fs.mkdir_p(lib_dir.dirname)
          (git.call('clone', CODE_REPO, lib_dir.to_path) unless lib_dir.directory?).then do
            Dir.chdir(lib_dir.to_path) { git.update(branch: CODE_BRANCH) }
          end
        end

        git.update(branch: FAVS_BRANCH)
      end
    end
  end

  class << self
    def call
      self.new.call
    end
  end

  protected

  # @return [String]
  def lib_name
    Pathname.new(CODE_REPO).basename('.git').to_s
  end

  # @return [Module<FileUtils::Verbose>, Module<FileUtils>]
  def fs
    FileUtils::Verbose
  end

  # @return [Module<Git>]
  def git
    Git
  end
end

# Simple wrapper built on top of git executable.
module Git
  class << self
    # Call a command.
    def call(*args, **opts)
      {
        exception: true,
        verbose: verbose?,
      }.each { |k, v| opts[k] = v unless opts.key?(k) }

      ['git'].concat(args).concat([opts[:verbose] ? nil : '--quiet'].compact).then do |arguments|
        system(*arguments, exception: opts[:exception])
      end
    end

    # Force update (with clean) on current path.
    def update(branch: 'main', **opts)
      [
        %w[clean --force],
        %w[pull],
        ['checkout', branch]
      ].each { |args| self.(*args, **opts) }
    end

    # Denote git is set in verbose mode (from env).
    def verbose?
      (ENV["#{ENV_PREFIX}_VCS_VERBOSE"] ||= 'false').then do |v|
        v == 'true' ? true : false
      end
    end
  end
end

App.call if __FILE__ == $0
