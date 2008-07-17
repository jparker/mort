set :application, 'mortgage'

set :user, 'jparker'
set :use_sudo, false

set :deploy_to, '/home/jparker/apps/mort'

set :repository, 'git@github.com:jparker/mort.git'
set :scm, :git
set :branch, 'master'

set :deploy_via, :copy

role :app, 'papango.urgetopunt.com'
role :web, 'papango.urgetopunt.com'
role :db, 'papango.urgetopunt.com'

namespace :sinatra do
  desc 'Stop app server'
  task :stop do
    run "#{current_path}/mortctl stop"
  end

  desc 'Start app server'
  task :start do
    run "#{current_path}/mortctl start -- -e production"
  end
end

before :deploy, 'sinatra:stop'
after :deploy, 'sinatra:start'
