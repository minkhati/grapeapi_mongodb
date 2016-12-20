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

#### (You can give all GET methods http://localhost:9292/v1/timecards.json in the browser for or use API client like POSTMAN). Please make sure the id used is auto generated. So use the id that has been generated in your system
Now let's list all the timecards in the database

    $ curl http://localhost:9292/v1/timecards.json
    => []

A blank array in response tells us there are no timecards yet.

## Adding a Timecard

     $ curl localhost:9292/api/v1/timecards -d "username=New user 20&occurrence=2016-12-20"

Now list all the timecards again, Your first timecard has now shown up

    $ curl http://localhost:9000/v1/timecards.json
    => [{"_id":{"$oid":"58596c70fb55cb1ea4658c78"},"card_id":20,"created_at":"2016-12-20T12:37:52.966-05:00","occurrence":"2016-12-20","total_hours":null,"updated_at":"2016-12-20T12:37:52.966-05:00","username":"New user 20"}]

## Updating a exisitng Timecard

    $ curl -X PUT localhost:9292/api/v1/timecards/20 -d "username= Updated New user 20&occurrence=2016-12-20"

Now list all the timecards again, Your updated timecard has now shown up.

    $ curl http://localhost:9000/v1/timecards.json
    => [{"_id":{"$oid":"58596c70fb55cb1ea4658c78"},"card_id":20,"created_at":"2016-12-20T12:37:52.966-05:00","occurrence":"2016-12-20","total_hours":null,"updated_at":"2016-12-20T12:40:04.087-05:00","username":" Updated New user 20"}]

## Deleting a exisiting Timecard

    $ curl -X DELETE localhost:9292/api/v1/timecards/20

Now list all the timecards again, Your deleted timecard has now not shown up.

    $ curl http://localhost:9000/v1/timecards.json


## Adding a Timeentry for a existing timecard_id

    $ curl localhost:9292/api/v1/timeentries -d "time=08:10:10&timecard_id=21"

Now list the timecard, Your first timeentry has now shown up

    $ curl http://localhost:9000/v1/timecards/21
    => {"_id":{"$oid":"58596ed4fb55cb1ea4658c79"},"card_id":21,"created_at":"2016-12-20T12:48:04.492-05:00","occurrence":"2016-12-20","timeentries":[{"_id":{"$oid":"58596f3bfb55cb1ea4658c7c"},"created_at":"2016-12-20T12:49:47.308-05:00","entry_id":35,"time":"2016-12-20T08:10:10.000-05:00","timecard_id":21,"updated_at":"2016-12-20T12:49:47.308-05:00"}],"total_hours":null,"updated_at":"2016-12-20T12:48:04.492-05:00","username":"New user 21"}

Now add one more timeentry with the same timecard_id

    $ curl localhost:9292/api/v1/timeentries -d "time=17:25:10&timecard_id=21"

Now list the timecard again, this time total_hours field will get updated and your second timeentry has now shown up

    $ curl http://localhost:9000/v1/timecards/21
    => {"_id":{"$oid":"58596ed4fb55cb1ea4658c79"},"card_id":21,"created_at":"2016-12-20T12:48:04.492-05:00","occurrence":"2016-12-20","timeentries":[{"_id":{"$oid":"58596f3bfb55cb1ea4658c7c"},"created_at":"2016-12-20T12:49:47.308-05:00","entry_id":35,"time":"2016-12-20T08:10:10.000-05:00","timecard_id":21,"updated_at":"2016-12-20T12:49:47.308-05:00"},{"_id":{"$oid":"585970b6fb55cb1ea4658c7d"},"created_at":"2016-12-20T12:56:06.774-05:00","entry_id":36,"time":"2016-12-20T17:25:10.000-05:00","timecard_id":21,"updated_at":"2016-12-20T12:56:06.774-05:00"}],"total_hours":9.25,"updated_at":"2016-12-20T12:56:06.779-05:00","username":"New user 21"}

Now if you will add more than two timeentry for the same card, it will update the last timeentry for the timecard_id and total_hours will get updated accordingly.

## Updating a exisiting Timeentry for a existing timecard_id

    $ curl -X PUT localhost:9292/api/v1/timeentries/36 -d "time=19:25:10&timecard_id=21"

Now list the timecard again, this time total_hours field will get updated and your second timeentry has now shown up with updated time

    $ curl http://localhost:9000/v1/timecards/21
    => {"_id":{"$oid":"58596ed4fb55cb1ea4658c79"},"card_id":21,"created_at":"2016-12-20T12:48:04.492-05:00","occurrence":"2016-12-20","timeentries":[{"_id":{"$oid":"58596f3bfb55cb1ea4658c7c"},"created_at":"2016-12-20T12:49:47.308-05:00","entry_id":35,"time":"2016-12-20T08:10:10.000-05:00","timecard_id":21,"updated_at":"2016-12-20T12:49:47.308-05:00"},{"_id":{"$oid":"585970b6fb55cb1ea4658c7d"},"created_at":"2016-12-20T12:56:06.774-05:00","entry_id":36,"time":"2016-12-20T19:25:10.000-05:00","timecard_id":21,"updated_at":"2016-12-20T13:02:25.827-05:00"}],"total_hours":11.25,"updated_at":"2016-12-20T13:02:25.832-05:00","username":"New user 21"}

## Deleting a exisiting Timeentry

    $ curl -X DELETE localhost:9292/api/v1/timeentries/35

Now list the timecard again, this time total_hours field will get set nil and your the given timeentry has deleted and not shown up.

    $ curl http://localhost:9000/v1/timecards/21
    => {"_id":{"$oid":"58596ed4fb55cb1ea4658c79"},"card_id":21,"created_at":"2016-12-20T12:48:04.492-05:00","occurrence":"2016-12-20","timeentries":[{"_id":{"$oid":"585970b6fb55cb1ea4658c7d"},"created_at":"2016-12-20T12:56:06.774-05:00","entry_id":36,"time":"2016-12-20T19:25:10.000-05:00","timecard_id":21,"updated_at":"2016-12-20T13:02:25.827-05:00"}],"total_hours":null,"updated_at":"2016-12-20T13:07:35.356-05:00","username":"New user 21"}



# Todo

* Implement Authentication and Authorization
* Consider all possible validations (Done only some basic validation)
* Make it work with databases other than MongoDB
* Implement grape-swagger gem to auto-generates Swagger-compliant documentation for Grape API
* Write some tests using the Rspec, API or any other tools
* Add support for multiple environments e.g. test, development and production.
* Add the robust logic to calculate Time Card total_hours considering the various possibilities
* Consider various required parameters to integrate it with the real production system
* Consider the throughput (efficiency) considering the huge number of API users
* Many more features are possible based on the end application
