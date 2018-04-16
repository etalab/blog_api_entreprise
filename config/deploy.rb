require 'mina/rails'
require 'mina/bundler'
require 'mina/git'
require 'mina/rbenv'
require 'colorize'

print "Deploy Blog on Watchdoge in production environment (no other choice)\n".green

set :user, 'deploy'
set :application_name, 'blog.entreprise.api.gouv.fr'
set :domain, 'blog.entreprise.api.gouv.fr'
set :deploy_to, "/var/www/blog_apientreprise"
set :repository, 'git@github.com:etalab/blog_apientreprise.git'

set :forward_agent, true
set :port, 22

set :branch, 'master'

task :remote_environment do
  set :rbenv_path, '/usr/local/rbenv'
  invoke :'rbenv:load'
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    set :bundle_options, fetch(:bundle_options) + ' --clean'
    invoke :'bundle:install'
    command %{ bundle exec jekyll build }
    invoke :'deploy:cleanup'
  end
end
