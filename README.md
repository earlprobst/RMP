Biocomfort Remote Management Platform
=====================================

Local install
-------------
You need ruby 1.9.2, PostgreSQL and all the gems listed in Gemfile.

MACOSX instructions
-------------------
I recommend installing homebrew and rvm: you'll need to install XCode before but they will make your life A LOT easier.

To install homebrew:

    ruby -e "$(curl -fsSLk https://gist.github.com/raw/323731/install_homebrew.rb)"
    brew update

To install a recent ruby 1.9.2 version via rvm:

    gem install rvm
    export PATH="./:$PATH:~/.gem/ruby/1.9.2/bin"
  	rvm install 1.9.2
  	rvm --default 1.9.2

Install git:

  	brew install git
    git config --global user.name "Your name"
    git config --global user.email your@email.com

Install postgresql and its ruby gems:

    brew install postgresql
    initdb /usr/local/var/postgres
  	env ARCHFLAGS="-arch x86_64" gem install postgres
  	env ARCHFLAGS="-arch x86_64" gem install pg

Ubuntu instructions
-------------------

To install a recent ruby 1.9.2 version via rvm:

    gem install rvm
    export PATH="./:$PATH:~/.gem/ruby/1.9.2/bin"
  	rvm install 1.9.2
  	rvm --default 1.9.2

Install git:

  	sudo aptitude install git
    git config --global user.name "Your name"
    git config --global user.email your@email.com

Install postgresql and its ruby gems:

    sudo aptitude install postgresql
    gem install postgres
    gem install pg
    
Both (MACOSX and Ubuntu)
------------------------

Clone the application:

    git clone git@github.com:aentos/biocomfort_rmp.git

Copy the .rvmrc.example and config/database.example.yml files, rename to .rvmrc and config/database.yml and adapt to your setup

If you need to create the database user or the databases:

    sudo su postgres
    createuser --pwprompt  # role: biocomfort_rmp pass: biocomfort_rmp
    createdb -E UTF8 -O biocomfort_rmp biocomfort_rmp_test
    createdb -E UTF8 -O biocomfort_rmp biocomfort_rmp_development
    exit

Update RubyGems and install bundler:

    gem update --system
    gem install bundler

Install dependencies:

    cd biocomfort_rmp
  	bundle install

Create local database:

    rake db:migrate

Start the local server:

    rails server
    open http://localhost:3000

Tests
-----

To run tests:

    rake test
  
If you want to execute only a kind of tests, for example, unit tests:

    rake test:units
  
To run cucumber tests:

    cucumber
  
It is posible to run the tests using parallel_tests (https://github.com/grosser/parallel_tests).

  Add to config/database.yml

    test:
      database: xxx_test<%= ENV['TEST_ENV_NUMBER'] %>
    
  Create additional database(s)

    rake parallel:create
  
  Copy development schema (repeat after migrations)

    rake parallel:prepare
  
  Run the tests:

    rake parallel:test          # Test::Unit
    rake parallel:features      # Cucumber

Deployment
----------

To deploy the application you should have registered your public key in the server machine.

To deploy in staging:

    cap staging deploy

and to deploy in production:

    cap production deploy


MyVitali
--------

The environment variables `MY_VITALI_TOKEN` and `MY_VITALI_URL` are used to connect to the My Vitali web service. If the variables are missing, the service
will fail always.


God (server)
------------

Install god gem

    sudo -i rvm gem install god

Make a rvm wrapper

    sudo -i rvm wrapper 1.9.2 bootup god

Copy and customize (with rails env) doc/god.init file as /etc/init.d/god and give permissions

    sudo cp /var/rails/biocomfort_rmp_staging/current/doc/god.init /etc/init.d/god
    sudo chmod +x /etc/init.d/god
    

Try the script:

    sudo /etc/init.d/god start
    sudo /etc/init.d/god status
    sudo /etc/init.d/god stop
    sudo /etc/init.d/god start

Add god init script to runlevels

    sudo update-rc.d god defaults
