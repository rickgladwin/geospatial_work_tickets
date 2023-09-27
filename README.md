# Work Ticket Tracker with Geospatial Display

## Description
This system receives, stores, and displays information about physical work projects
like road work or municipal work involving excavation.

A Ticket is the primary record, holding information about the work request, the
Excavators doing the work, and address and geospatial data about the work location.

An Excavator is a record belonging to the ticket, holding information about the company
and work crew doing the work.

The system:
* receives HTTP POST requests with Ticket and Excavator data
* stores Ticket and Excavator data in a database
* displays Ticket details and map data

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
    * If not, install it (e.g. with Homebrew `brew install postgresql@14`)
  * if PostgreSQL is installed using Homebrew, run this command to see the installation
locations, start commands, etc.
    * `brew info postgresql` or `brew info postgresql@14`
  * use the start command from the output of `brew info...`, e.g.
    * `brew services start postgresql@14`
  * OR start postgresql manually:
    * `pg_ctl -D /usr/local/var/postgres -l logfile start`
  * ensure postgres is running:
    * `pg_ctl -D /usr/local/var/postgres status`
  * create the Rails databases: `rails db:create`
  * run any pending migrations: `rails db:migrate`

## Build
If you need to modify the styles governed by tailwind, run `./bin/dev` to regenerate the stylesheets.

This will also start the rails server with a watcher to check for modified views, layouts, etc.

## Run
* from the command line:
  * `rails server`
  * In a browser, visit the URL output by the `rails server` command (e.g. "Listening on http://127.0.0.1:3000")

## Test
### Unit tests
* from the command line (or IDE):
  * `bundle exec rspec -f documentation` (run all specs with documentation format)

## Notes


## Things I would change
* Ideally I would build any new app that would be used by multiple parties or
stay active for any period of time in a Docker container, for better version
management and portability. But this is a small, temporary app.
* The API currently has no authorization built in. As this is simply an exercise to
be viewed by a restricted list of people, an API without auth is acceptable, but
in any production environment, given the API endpoint's ability to affect the state
of the system, the POST ticket_data endpoint should use an API key and/or other
auth methods.
* The project includes .rbs files (type declarations) for some classes and methods,
but not all. In a long-term/production environment, type declarations can help prevent
errors at development time, make function and class definitions more precise and
obvious for developers, and can improve performance at runtime (especially since Ruby
3.1.0 onward includes a JIT compiler – compiling and memory management are typically
aided by type declarations)
* There is very little validation and differential handling for cases where the json
data is invalid or incomplete. These cases could be handled in a way that still allows
the UI to load, for example:
  * If there are no `ticket.digsite_info` coordinates, generate and display the Google
map using the `ticket.primary_service_area_code` and a default zoom level
  * If there's not enough useful information to generate the Google map, don't display one
* Make the column display on the `Tickets` index table dynamic, showing more or fewer
columns depending on the viewport size, prioritizing the "Show" link and other key details
* add more test cases and additional test scopes