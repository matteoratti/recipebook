# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

    ruby 3.0.0

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
  deploy on heroku use x86_64-linux platform on gemfile.lock
  push to heroku
    git push heroku main
  logs on terminal
    heroku logs --tail  display
  run migrations
    heroku run rails db:migrate run 

* auto correct code with rubocop
    before any commit or push:
    rubocop --autocorrect-all



Commands:

* creates new rails app with bootstrap installed and postgresql DB
  rails new recipebook --css bootstrap --database=postgresql

creates the DB
  rails db:create

Starts Dev server
  bin/dev



TO DO:

Rails/Ruby Solid principles 


* Tests
    >  If you running tests for the first time you need to build css and js with: `yarn build:css` and `yarn build` before start tests. Otherwise run: `.bin/dev` to trigger ./procfile.dev and trigger both command and run rails server.
