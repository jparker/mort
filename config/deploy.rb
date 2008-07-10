set :application, 'mortgage'

set :user, 'jparker'
set :use_sudo, 'false'

set :deploy_to, '/home/jparker/apps/mortgage'

set :repository, 'git@github.com:jparker/mortgage.git'
set :scm, :git
set :branch, 'master'

set :deploy_via, :remote_cache

role :app, 'papango.urgetopunt.com'
role :web, 'papango.urgetopunt.com'
role :db, 'papango.urgetopunt.com'

namespace :deploy do
  desc 'Custom start task'
  task :start do
    run "cd #{deploy_to}/current && ./script/start production >#{deploy_to}/log/access.log 2>#{deploy_to}/log/error.log"
  end
  
  desc 'Custom stop task'
  task :stop do
    run "cd #{deploy_to}/current && ./script/stop"
  end
  
  desc 'Custom restart task'
  task :restart do
    deploy.stop
    deploy.start
  end
end
