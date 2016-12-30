# bicimapa-web

## How to run with docker

Clone the project

    git clone git@github.com:bicimapa/bicimapa-web.git
    
Build the docker containers

    cd bicimapa-web
    docker-compose build
    
Install gems

    docker-compose run app bundle install

Setup database

    docker-compose run app bundle exec rake db:setup

Configure the API keys
    
    cp app/application.yml.example app/application.yml
    vim app/application.yml
    
> The most important one is ```GOOGLE_MAP_API_KEY```

Run

    docker-compose up
    
Then go to [http://localhost:3000](http://localhost:3000) or [http://localhost:3000/en/admin](http://localhost:3000/en/admin) (login: ```admin@example.com```, password: ```password```)
