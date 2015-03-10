#Wager-Tagger Scraper
Scrapes the information off of Sportsbook.ag and serves the information via an API. It sprinkles in a little bit of PhantomJS to help with remote authentication.

##Usage
Credentials are supplied by setting the environment variables SB_USERNAME and SB_PASSWORD. An API key is required

##Endpoints
The following endpoints are available

### GET /api/v1/tickets/recent[?start_date=mm/dd/yyyy]
Retrieve all tickets from the past 30 days. If a start date is provided all tickets from 30 days prior to the start-date will be returned

### GET /api/v1/tickets/all
Retrieve all tickets from all time

## More Information
See the [Wager-Tagger-Go-API](https://github.com/hoitomt/wager-tagger-go-api) for more information about the project
