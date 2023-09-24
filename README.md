# Work Ticket Tracker with Geospatial Display

## Description
* receives HTTP POST requests with ticket data
* stores ticket data in database
* displays ticket details and map data

## Requirements
* Ruby 3.2.2
* PostgreSQL 14.8

## Installation
### codebase
* clone this repo
* cd into the repo's root folder
* from the command line:
  * `gem install bundler`
  * `bundle install`
### database
* from the command line:
  * ensure PostgreSQL is installed locally:
    * `postgres --version`
    * If not, install it
  * if PostgreSQL is installed using Homebrew, run this command to see the installation
locations, start commands, etc.
    * `brew info postgresql`
  * use the start command from the output of `brew info...`, e.g.
    * `brew services start postgresql@14`
  * OR start postgresql manually:
    * `pg_ctl -D /usr/local/var/postgres -l logfile start`
  * ensure postgres is running:
    * `pg_ctl -D /usr/local/var/postgres status`
  * create the Rails databases: `rails db:create`

## Build
If you need to modify the styles governed by tailwind, run `./bin/dev` to regenerate the stylesheets.

This will also start the rails server with a watcher to check for modified views, layouts, etc.

## Run
* from the command line:
  * `rails server`
  * In a browser, visit the URL output by the `rails server` command (e.g. "Listening on http://127.0.0.1:3000")

## Test


## Notes

