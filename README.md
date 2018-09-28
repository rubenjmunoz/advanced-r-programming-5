# advanced-r-programming-5
Repository for the course 732A94 Advanced Programming in R at Linköping University 2018. Assignment 5.

We are going to use the `Kolada API`. The format is perfect (JSON), the API has a documentation and follows the REST principle. The documentation can be found [here](https://www.kolada.se/appspecific/rka/download/api/KoladaSDKv1-dokumentation.pdf).

A Tutorial how to consume a REST-API in R can be found [here](https://www.programmableweb.com/news/how-to-access-any-restful-api-using-r-language/how-to/2017/07/21).

The packages needed are [httr](https://cran.r-project.org/web/packages/httr/index.html) for the HTTP communication and [jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html) for mapping JSON data to data.frames.

## ToDo
- Analyse data and decide which data we want to visualize.
- Make HTTP calls to receive the data and map it to a data.frame.
- Build the Shiny application
  - "At least one interactive widget should be used." -> Seems like nothing to "fancy"
- Package documentation
- Unit Tests
- Vignette
