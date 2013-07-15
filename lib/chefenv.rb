require 'thor'
require 'fileutils'
require "chefenv/version"
require 'pathname'

module ChefEnv
  class Tasks < Thor

    desc "list", "list the available chef environments"
    def list
      current = current_environment
      available_environments.each do |env|
        puts "#{(env == current) ? '*' : ' '} #{env}"
      end
      if available_environments.empty?
        puts "No Environments Available"
      end
    end

    desc "use ENV", "use a particular environment"
    def use(env="")
      if available_environments.include?(env)
        select_environment(env)
      else
        puts "'#{env}' is not a known environment."
      end
      list
    end

    desc "current", "display the name of the current environment"
    def current()
      puts current_environment
    end

    desc "init", "initialize the environment"
    def init()
      FileUtils.mkdir_p(chefenv_dir) unless File.directory?(chefenv_dir)
      FileUtils.mkdir_p(environments_dir) unless File.directory?(environments_dir)
      FileUtils.safe_unlink(chef_dir)
      list
    end

    no_tasks do

      def chef_dir
        File.expand_path("~/.chef")
      end

      def chefenv_dir
        dir = ENV['CHEFENV_DIR'].to_s 
        dir = File.expand_path("~/.chefenv") if dir.empty?
        dir
      end

      def environments_dir
        File.expand_path('environments', chefenv_dir)
      end

      def environment_dir(environment)
        File.expand_path(environment, environments_dir)
      end

      def available_environments
        Pathname.new(environments_dir).children.select { |c| c.directory? }.map { |d| d.basename.to_s }
      end

      def environment_available?(env)
        available_environments.include?(env)
      end

      def select_environment(env)
        unless current_environment == env
          File.write(File.expand_path("#{chefenv_dir}/current"), env)
          FileUtils.safe_unlink(chef_dir)
          FileUtils.symlink(File.join(environments_dir, env), chef_dir)
        end
      end

      def current_environment
        begin
          Pathname.new(File.readlink(File.expand_path('~/.chef'))).split.last.to_s
        rescue Errno::ENOENT
          nil  
        end
      end
    end

  end
end
