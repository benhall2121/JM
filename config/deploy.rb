set :application, "jm"
set :repository,  "git@github.com:benhall2121/JM.git"
set :rails_env, "production"

set :scm, "git"

set :deploy_via, :remote_cache
server = '50.57.64.194'

set :user, 'ben'
set :password, '212134'
set :use_sudo, false

role :web, server
role :app, server
role :db,  server, :primary => true

set :deploy_to, "/home/#{user}/apps/#{application}"


