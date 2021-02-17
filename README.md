# Staffomatic User Management

This is our Lekker Rails-API :rocket:

![Rspec](https://github.com/lekkercode-com/staffomatic_user_management/workflows/Rspec/badge.svg)

## Get it up and running

### start up docker

```bash
$ docker-compose up
Building api
Step 1/10 : FROM ruby:2.6.6-alpine
...
server --help` for more startup options
api_1    | Puma starting in single mode...
api_1    | * Puma version: 5.2.0 (ruby 2.6.6-p146) ("Fettisdagsbulle")
api_1    | *  Min threads: 5
api_1    | *  Max threads: 5
api_1    | *  Environment: development
api_1    | *          PID: 1
api_1    | * Listening on http://0.0.0.0:3189
api_1    | Use Ctrl-C to stop
```

use `--build api` if you changed e.g. Gemfile

```bash
$ docker-compose up --build api
```

### Check if app is running, expect a `ActiveRecord::NoDatabaseError`:

```bash
$ open http://localhost:3189
# or
$ curl http://localhost:3189
```

#### Follow the logs

```bash
$ tail -f log/development.log
# or for specs:
$ tail -f log/test.log
```

## Prepare database

```bash
$ docker-compose run api bundle exec rake db:prepare
  Creating staffomatic_user_management_api_run ... done
  Created database 'staffomatic_user_management_development'
  Created database 'staffomatic_user_management_test'
```

### Run specs

```bash
$ docker-compose run api bundle exec rspec
```

if you see a migration error, you might need to run:

```bash
$ docker-compose run -e RAILS_ENV=test api bundle exec rake db:prepare
```

# Cleanup Docker

Stop the container(s):
```bash
$ docker-compose down
```

Delete all containers:
```bash
$ docker rm -f $(docker ps -a -q)
```

Delete all volumes:
```bash
$ docker volume rm staffomatic_user_management_db_data
# OR remove all
$ docker volume rm $(docker volume ls -q)
```

# API Documentation

### Signup User
##### (POST /signup)

```bash
$ curl --request POST --header "Content-Type: application/json" \
          http://localhost:3189/signup --data \
          '{"data": {"attributes": {"email": "admin@easypep.de", "password": "welcome", "password_confirmation": "welcome"}}}'
```

### Authenticate User
##### (POST /authentications)

```bash
$ curl --request POST --header "Content-Type: application/json" \
          http://localhost:3189/authentications --data \
          '{"authentication": {"email": "admin@easypep.de", "password": "welcome"}}'
```

### List Users
##### (GET /users)

```bash
$ curl --header \
        "Authentication: Bearer JWT_TOKEN" \
        --header "Content-Type: application/json" \
        http://localhost:3189/users
```

### Archive User
##### (PUT /users)

```bash
$curl --request PUT --header \
        "Authentication: Bearer JWT_TOKEN" \
        --header "Content-Type: application/json" \
        http://localhost:3189/users/:id --data \
        '{"user": { archived": true }'
```

Note - Pass user 'id' to archive or un-archive user.

Code Explanation -

1. I have added archived(boolean) attribute in user table to check whether user archived or not.
1. I have created 'archive_user_history' table to track user archived history.

Open Points -

1. Can user archive or un-archive self? (Not taken care in code)
2. If authenticated user archive any user, will that user be archived for other users or not? (I have implemented based on "User will be archived for other users also.")
