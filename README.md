<h1 align="center"> Pierpont Global API </h1>
This is the pierpont api, this allows other applications to store and retrieve information given by manheim.

## Configuration
These is build using the **Ruby** language alongside it's framework **Rails** The configuration that describes this project is:
* Ruby ~> 2.5.1
* Rails ~> 5.2.1

The API requires that docker is installed, so make sure you have the latest version of docker configured in the machine. 

## Database
You can skip this part if you are intended to use Docker since it will manage all of this automatically.

The project uses a Postgres Database, so it is necessary to install the required client and the gems specified in the **Gemfile** of the repository, it's important to edit the **database.yml** file to match your system database configuration.

For creating the database run the command `rails db:create`, once it is done run the command `rails db:migrate` which will generate the corresponding tables and associations.

## Running locally
For running this component locally run the command `rails s`, it will then start the process of initiating the server locally on localhost with the port number 3000.

If you are running it from docker just ```cd``` into the project file and run ```docker-compose build``` and then ```docker-compose up``` and that is it, the server would be running on port 3000 of the local host, also, the docker compose ahas other services configured to help de development of the application to be easier, this services are:
* Elasticsearch
* Logstash
* Kibana

These components are useful for managing the logs generated by the server and showing some extra information about them, they are also useful for graphing all the data it gadders.

## Testing the API
If you wish to test the endpoints we strongly recommend you to use our [Postman configuration](https://documenter.getpostman.com/view/5352985/RWgm4gT1), also there is an GUI in the routes of the application that will let you test the endpoints from a browser but that solution is not always up to date, [Test API from browser](http://0.0.0.0:3000/api-docs/index.html).  