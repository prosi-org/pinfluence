# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'pinfluence'
set :repo_url, 'git@github.com:rafaels88/pinfluence.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :linked_files, %w{.env.production}
set :linked_dirs, %w{tmp/pids}

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.3.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/pinfluence'

set :ssh_options, {
  forward_agent: true,
  port: 3622
}

set :bundle_without, [:darwin, :development, :test]
set :bundle_flags, "--deployment"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  task :precompile do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && #{fetch(:rbenv_prefix)} bundle exec hanami assets precompile"
    end
  end

  task :db_migrate do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && HANAMI_ENV=production #{fetch(:rbenv_prefix)} bundle exec hanami db migrate"
    end
  end

  after :publishing, :db_migrate
  after :publishing, :precompile
end