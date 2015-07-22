# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'blog'
set :repo_url, 'git@github.com:guoyoujin/blog.git'

set :scm, :git
set :pty, true
set :stages, ["staging", "production"]
set :default_stage, "staging"
# Default value for :linked_files is []
set :linked_files, %w{ config/database.yml }
# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/assets}
# Default value for default_env is {}
set :rvm_type, :user
# set :rvm_ruby_version, '2.2.2'
set :default_env, { rvm_bin_path: '~/.rvm/bin' }

# Default value for keep_releases is 5
set :keep_releases, 5

set :ssh_options, {
  user: 'gyj',
  keys: [File.expand_path('~/.ssh/id_rsa')],
  forward_agent: false,
  auth_methods: %w(publickey)
}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end

  desc "update crotab with whenever"
  task :update_crontab do
    on roles(:all) do
      within release_path do
        execute :bundle, :exec, "whenever --update-crontab #{fetch(:whenever_identifier)} "
      end
    end
  end

  task :rake do
    on roles(:all), in: :sequence, wait: 5 do
      within release_path do
        execute :rake, ENV['task'], "RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
    # cap staging deploy:rake task=add_headimg:seed
  end

  after :restart, :'puma:restart'
  after :restart, :'deploy:update_crontab'
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

  after :publishing, :restart
  after :finishing, 'deploy:cleanup'

end
