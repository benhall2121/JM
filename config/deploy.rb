set :application, "benerino.com"
set :user, "ben"
set :repository, "git@github.com:benhall2121/JM.git"

set :deploy_to, "/home/#{user}/public_html/#{application}"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, application
role :web, application
role :db,  application, :primary => true
