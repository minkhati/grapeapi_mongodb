# [Grape](https://github.com/intridea/grape) + [Mongoid](https://docs.mongodb.com/ruby-driver/master/mongoid/) REST API for TIME CARD ENTRY

## What is this?

* Grape is micro-framework for creating REST-like APIs in Ruby.
* Mongoid is the officially supported ODM (Object-Document-Mapper) framework for MongoDB in Ruby.

Together you can create a highly scalable API and use the nice features of Grape to specify how your REST API will work.

## Getting Started

First Install Mongodb in your local system (using Homebrew)

    Update Homebrew’s package database

        $ brew update

    Install MongoDB

        $ brew install mongodb

Next Run MongoDB

   Create the data directory

        $ mkdir -p /data/db

   Specify the path of the data directory

        $ mongod --dbpath <path to data directory created before>

Stop MongoDB

   To stop MongoDB, press Control+C in the terminal where the mongod instance is running


Next take a copy of the project

    git clone https://github.com/minkhati/grapeapi-mongodb.git
    cd grapeapi-mongodb/

Install dependencies

    bundle install

Finally start the RACK server and you're done!

    $ rackup


Now let's list all the timecards in the database:

    curl http://localhost:9292/v1/timecards.json
    => []

A blank array in response tells us there are no timecards yet.

## Adding a Timecard

    curl -X POST -d '{"timecard":{"username":"Sample User","occurrence":"2016-12-19"}}' http://localhost:9000/v1/timecards/create

Now list all the timecards again

    curl http://localhost:9000/v1/timecards.json
    => [{"body":"this is my message","created_at":"2012-12-19T10:10:10-10:10","id":1,"username":"sample User","updated_at":"2012-12-19T10:10:10-10:10"}]

Your first timecard has now shown up.

