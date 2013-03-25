require 'thor'
require 'fileutils'
require "chefenv/version"

module ChefEnv
  # Your code goes here...
  class Tasks < Thor

    desc "list", "list the available chef environments"
    def list
      current = current_environment
      available_environments.each do |env|
        puts "#{(env == current_environment) ? '*' : ' '} #{env}"
      end
      if available_environments.size == 0
        puts "No Environments Available"
      end
    end

    desc "use ENV", "use a particular environment"
    def use(env="")
      unless env == current_environment
        if available_environments.include?(env)
          select_environment(env)
        else
          puts "#{env} is not a known environment"
          list
        end
      end
    end

    desc "init", "initialize the environment"
    def init()
      FileUtils.mkdir_p(File.expand_path("~/chef")) unless File.exists?("~/chef")
      current = current_environment

      if current.nil?
        puts 'No environment selected. Picking the first one that I find. You can change it with `chefenv use ENV`'
        available = available_environments
        if available.empty?
          puts "No environments are available"
        else
          puts "Trying to use '#{available.first}'"
          use(available.first)
        end
        current = current_environment
        list
        return
      end

      unless available_environments.include?(current)
        puts "'#{current}' is selected as the current environment, but it is not valid. Please select a different environment"
        `rm -f ~/.chef`
        `rm -f ~/chef/current`
        list
        return
      end

    end

    no_tasks do
      def available_environments
        Pathname.new(File.expand_path("~/chef")).children.select { |c| c.directory? }.map { |d| d.basename.to_s }
      end

      def select_environment(env)
        File.write(File.expand_path("~/chef/current"), env)
        `rm -f ~/.chef`
        `ln -s ~/chef/#{env} ~/.chef`
      end

      def current_environment
        begin
          File.read(File.expand_path("~/chef/current")).chomp
        rescue Errno::ENOENT
          nil  
        end
      end
    end

  end
end
