namespace :config do
  task :environment do
    set :config_templates_path, "lib/capistrano/tpls"
    set :config_path, "#{fetch(:deploy_to)}/shared/config"
  end

  desc "Unicorn config upload to server"
  task :setup => :environment do
    on roles(:all) do |host|
      if "#{fetch(:stage)}" == "production"
        upload! "#{fetch(:config_templates_path)}/database_production.yml" , "#{fetch(:config_path)}/database.yml"
        # upload! "#{fetch(:config_templates_path)}/config_production.yml" , "#{fetch(:config_path)}/config.yml"
        # upload! "#{fetch(:config_templates_path)}/carrierwave_production.rb" , "#{fetch(:config_path)}/initializers/carrierwave.rb"
        # upload! "#{fetch(:config_templates_path)}/redis_production.rb" , "#{fetch(:config_path)}/initializers/redis.rb"
      else
        upload! "#{fetch(:config_templates_path)}/database_staging.yml" , "#{fetch(:config_path)}/database.yml"
        upload! "#{fetch(:config_templates_path)}/config_staging.yml" , "#{fetch(:config_path)}/config.yml"
        upload! "#{fetch(:config_templates_path)}/carrierwave_staging.rb" , "#{fetch(:config_path)}/initializers/carrierwave.rb"
        upload! "#{fetch(:config_templates_path)}/redis_staging.rb" , "#{fetch(:config_path)}/initializers/redis.rb"
      end
    end
  end

end