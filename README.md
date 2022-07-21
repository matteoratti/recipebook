# Recipe Book README

Manage your own recipes with this wep app made in Ruby on Rails.

## Ruby version
  * ruby 3.0.0

## System dependencies

  * Active Storage

  RecipeBook uses libvips library, you need to install it in your system.
  Follow this link for installation instructions:

  https://www.libvips.org/install.html


## Configuration

## Testing

run System testing
```bash
  bin/rails test:system
```

run tests
```bash
  rails test
```

## Database

DB creation
```bash
  rails db:create
```

DB Drop
```bash
rails db:drop
```

Make DB migrations
```bash
rails db:migrate
```

## Services (job queues, cache servers, search engines, etc.)

## Deployment

Add this string platform on `gemfile.lock` under PLATFORMS.
```bash
x86_64-linux
``` 

Push to heroku
```bash
git push heroku main
```

## Heroku

Login to Heroku CLI

```bash
 heroku login
```

Run Migrations on Heroku
```bash
heroku run rails db:migrate run
```

Logs on terminal
```bash
heroku logs --tail
```

## Development

creates new rails app with bootstrap and PostgreSQL
```bash
rails new recipebook --css bootstrap --database=postgresql
```

Starts Dev server

    bin/dev
   

Auto correct code with Rubocop before any commit or push.
```bash
rubocop --autocorrect-all
```

display all routes with their helpers on browser:
  http://localhost:3000/rails/info/routes

## Generators

Model
```bash
rails g model user email:string username:string
```

Scaffold Controller
```bash
rails g scaffold_controller Model field1 field2
```

## VS Code


Rails/Ruby Solid principles 


* Tests
    >  If you running tests for the first time you need to build css and js with: `yarn build:css` and `yarn build` before start tests. Otherwise run: `.bin/dev` to trigger ./procfile.dev and trigger both command and run rails server.
Preview README.md `shift+command+v`
