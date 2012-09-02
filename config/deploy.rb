require "bundler/capistrano"
#require "rvm/capistrano"
set :application, "rd-920_tracking"
set :repository,  "git://github.com/bsherman26/rd-920_tracking.git"
#set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system
#set :rvm_ruby_string "1.9.3"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/apps/rd-920_tracking"         # Change from the default deploy directory ("/u/apps/#{application}")
set :user, "brian"                                 # This is not necessary, but if the user name was different it is needed
#set :use_sudo, false

role :web, "basileis.com"                          # Your HTTP server, Apache/etc
role :app, "basileis.com"                          # This may be the same as your `Web` server
role :db,  "basileis.com", :primary => true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"

default_run_options[:pty] = true                   # I had to add this so it would prompt for a password

# Link the folder specified in config.assets.prefix to shared/assets
load 'deploy/assets'

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end
end
