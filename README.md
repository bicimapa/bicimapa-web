[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0) [![Code Climate](https://img.shields.io/codeclimate/github/bicimapa/bicimapa-web.svg)](https://codeclimate.com/github/bicimapa/bicimapa-web) [![Dependency Status](https://www.versioneye.com/user/projects/5897f3f3f55eb2003257f64a/badge.svg)](https://www.versioneye.com/user/projects/5897f3f3f55eb2003257f64a)

# bicimapa-web

Crowdsourced map for urban cyclists. 🚴 [https://bicimapa.com](https://bicimapa.com)

![Logo Bicimapa](https://github.com/bicimapa/bicimapa-assets/blob/master/logo%20bicimapa.png?raw=true)

![Screenshot main page](https://github.com/bicimapa/bicimapa-assets/blob/master/screenshot_main_page.png?raw=true)

## How to run with docker 🐳
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
    
Then go to 
 * [http://localhost:3000](http://localhost:3000) 
 * [http://localhost:3000/en/admin](http://localhost:3000/en/admin) (login: ```admin@example.com```, password: ```password```)

## Deploy

Run

    eval $(ssh-agent)
    ssh-add ~/.ssh/id_rsa
    cap production deploy

## What is included?

 * Spacial database (PostGIS)
 * API for mobile apps (Android / iOS)
 * Administration backend
 * Optimized map in frontpage
 
## License

[GPL v3](https://github.com/bicimapa/bicimapa-web/blob/master/LICENSE.txt)
 
