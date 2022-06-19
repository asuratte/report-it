# README

## Versions

- ruby 2.6.5
- rails 6.1.6

## Database Setup

- Install postgresql locally
- Create 2 databases:
    - report_it_development, password cs6920t4
    - report_it_test, password cs6920t4

## Installation

- bin/bundle install
- bin/yarn install
- bin/rails webpacker:install
- bin/rails db:migrate

## Database Population

- rake import:csv_model
    - Populates Users table
- Run the following query on the development database:
    
    ```jsx
    INSERT INTO 
        themes (name, created_at, updated_at)
    VALUES
        ('Theme 1',NOW(),NOW())
    ;
    ```
    
    - Populates the Themes table

## Run Locally

- bin/rails test -b 0.0.0.0

## Run Unit Tests

- bin/rails test

## Sample User Accounts

- Admin:
    - admin@email.com
    - password
- Official:
    - official@email.com
    - password
- Resident:
    - resident@email.com
    - password

## Production URL

http://www.reportit.tech/