# RARMS - Rest Api with Ruby, MongoDB and Sinatra

# design decisions
- Rails MVC framework discarded as being too heavyweight for the needs of this API
- Sinatra chosen as a lightweight, fast-loading framework suitable for a JSON REST API
- MongoDB selected with support from the Mongoid gem for ODM solution
- Firebase considered as an alternative dynamic JSON/HTTP persistence solution 

# startup
- Start MongoDB `./mongod`
- Run with `ruby app.rb -o $IP -p $PORT`
- RARMS can be run from Cloud9 via https://c9.io/laurencetimms/rarms

## todo
- create test suite
- create Rakefile
- add api metering & usage scheduling
- harden (owasp) + deep pen test + schedule regular pen test 
- secure the database
- dynamic config: switch between production and dev databases based on host url
- embed metrics across the api and ruby vm (ie metrics-jvm-jars + new relic)

# thanks
- originally cloned from bananatron/sinatra-firebase and then extensively modified
