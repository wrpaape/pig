# Game of Pig


## Setup
 - run `bundle install`

## How to Play
 - run `ruby bin/play.rb` to start the game


## How to run the tests
 - run `ruby spec/NAME_OF_TEST.rb` to run a test file



# Project Structure Readme
This folder structure should be suitable for starting a project that uses a database:

* Fork this repo
* Clone this repo
* `rake generate:migration <NAME>` to create a migration (Don't include the `<` `>` in your name, it should also start with a capital)
* `rake db:migrate` to run the migration and update the database
* Create models in lib that subclass `ActiveRecord::Base`
* ... ?
* Profit


## Rundown

```
.
├── Gemfile             # Details which gems are required by the project
├── README.md           # This file
├── Rakefile            # Defines `rake generate:migration` and `db:migrate`
├── config
│   └── database.yml    # Defines the database config (e.g. name of file)
├── console.rb          # `ruby console.rb` starts `pry` with models loaded
├── db
│   ├── dev.sqlite3     # Default location of the database file
│   ├── migrate         # Folder containing generated migrations
│   └── setup.rb        # `require`ing this file sets up the db connection
└── lib                 # Your ruby code (models, etc.) should go here
    └── all.rb          # Require this file to auto-require _all_ `.rb` files in `lib`
```


