# README

Rails 7.1 with Ruby 3.3.1


Database: PostgreSQL


# Setup
Run Bundler:
```
bundle
```

To create the database:
```
rails db:migrate
```

To run the test suite:
```
rspec
```

# Try the API

First, start the server:
```
rails s
```

### Create a User
Send a POST to http://localhost:3000/api/user with this body:
```
{
  "email": "test@example.com",
  "password": "test123",
  "password_confirmation": "test123"
}
```
You will receive a 201 response:
```
{
  "user": {
  "email": "test@example.com",
  "authentication_token": "75n_syJ_q4Vst4CFnVwk"
  }
}
```

### Sign In
Send a POST to http://localhost:3000/api/sessions with this body:
```
{
  "email": "test@example.com",
  "password": "test123"
}
```
You will receive a 201 response:
```
{
  "user": {
  "email": "test1@example.com",
  "authentication_token": "FB4y_cxyWdVDSSV7hyQZ"
  }
}
```

### Report a User's Game Completion Event
Send a POST to http://localhost:3000/api/user/game_event
with these headers:
```
X-User-Email: test@example.com
X-User-Token: FB4y_cxyWdVDSSV7hyQZ
```
You will receive a 201 response with no body.

### Receive a User's Details
Send a GET to http://localhost:3000/api/user
with these headers:
```
X-User-Email: test@example.com
X-User-Token: FB4y_cxyWdVDSSV7hyQZ
```
You will receive a 200 response:
```
{
  "user": {
    "id": 1,
    "email": "test@example.com",
    "stats": {
      "total_games_played": 1
    }
  }
}
```