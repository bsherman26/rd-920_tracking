# GENERAL
default_run_options[:pty] = true                    # I had to add this so it would prompt for a password
require "bundler/capistrano"                        # Add bundle install to deploy task
load 'deploy/assets'                                # Link the folder specified in config.assets.prefix to shared/assets

# APPLICATION
set  :application, "rd-920_tracking"

# REPOSITORY INFO
set  :scm, :git
set  :repository,  "git://github.com/bsherman26/rd-920_tracking.git"

# SERVER INFO
set  :deploy_to, "/apps/rd-920_tracking"            # Change from the default deploy directory ("/u/apps/#{application}")
set  :user, "brian"                                 # This is not necessary, but if the user name was different it is needed
set  :use_sudo, false                               # Prevent the use of sudo. This is important if the user specified below doesn't have sudo_privliges (I don't think sudo is needed for anything if privleges are set right and the user has database access)
role :web, "basileis.com"                           # Your HTTP server, Apache/etc
role :app, "basileis.com"                           # This may be the same as your `Web` server
role :db,  "basileis.com", :primary => true         # This is where Rails migrations will run

# ADDITIONAL TASKS
namespace :deploy do                                # Default settings for Passenger restart etc. (# If you are using Passenger mod_rails uncomment this:)
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end

 task :symlink_shared do                            # Added task to link shared database.yml into current release. This protects any passwords etc in the file.
   run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
 end
end

# ADDED TASK EXECUTION
after 'deploy:update_code', 'deploy:symlink_shared' # Run deploy:symlink_shared after running deploy:update_code


# STUFF I DIDN'T USE

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

#role :db,  "your slave db-server here"
