# Pierpont Global API
This is the pierpont api, this allows other applications to store and retrieve information given by manheim.

## Configuration
These is build using the **Ruby** language alongside it's framework **Rails** The configuration that describes this project is:
* Ruby ~> 2.5.1
* Rails ~> 5.2.1

## Database
The project uses a Postgres Database, so it is necessary to install the required client and the gems specified in the **Gemfile** of the repository, it's important to edit the **database.yml** file to match your system database configuration.

For creating the database run the command `rails db:create`, once it is done run the command `rails db:migrate` which will generate the corresponding tables and associations.

## Test
TODO

## Running locally
For running this component locally run the command `rails s`, it will thge strat the process of initiating the server locally on localhost with the port number 3000.