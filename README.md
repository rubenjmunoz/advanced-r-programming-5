# Advanced-r-programming-5
![Build Status](https://travis-ci.com/rubenjmunoz/advanced-r-programming-5.svg?token=3uxYSHZ47KLsHkqsdvws&branch=master)

Repository for the course 732A94 Advanced Programming in R at Linköping University 2018. Assignment 5.

We are going to use the `Kolada API`. The format is perfect (JSON), the API has a documentation and follows the REST principle. The documentation can be found [here](https://www.kolada.se/appspecific/rka/download/api/KoladaSDKv1-dokumentation.pdf).

A Tutorial how to consume a REST-API in R can be found [here](https://www.programmableweb.com/news/how-to-access-any-restful-api-using-r-language/how-to/2017/07/21).

The packages needed are [httr](https://cran.r-project.org/web/packages/httr/index.html) for the HTTP communication and [jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html) for mapping JSON data to data.frames.

## ToDo
- ~~Analyse data and decide which data we want to visualize~~.
- ~~Make HTTP calls to receive the data and map it to a data.frame.~~
- Refactor code and make it more beautiful
- ~~Copy left side code to the right side~~
- Implement selection of multiple KPIs
- ~~More fancy stuff like color, etc.~~
- ~~Package documentation~~
- ~~Unit Tests~~
- Vignette
- ~~TravisCI and create R package~~

## Example for REST-Call
This is an example how the libraries can be used to fetch data. Be aware, that this example does not handle pagination.

```r
library(httr)
library(jsonlite)

# Prepare Call
base = "http://api.kolada.se/"
endpoint = "v1/ou/data/peryear/N15030/2011"
webCall = paste(base, endpoint, sep="")

# Execution
response = GET(webCall)

# Deserialization
result = content(response, "text", encoding = "utf-8")
result.data.frame = as.data.frame(fromJSON(result, flatten = TRUE))
```

For this call, the response looks like this:

```r
> head(result.data.frame)
  values.kpi    values.ou values.period values.value values.value_m values.value_f                                                                   next. count
1     N15030 V150114G0R01          2011         84.4             NA             NA http://api.kolada.se/v1/ou/data/peryear/N15030/2011?page=2&per_page=100   100
2     N15030 V150114G0R02          2011         81.8             NA             NA http://api.kolada.se/v1/ou/data/peryear/N15030/2011?page=2&per_page=100   100
3     N15030 V150115G0R01          2011         84.3             NA             NA http://api.kolada.se/v1/ou/data/peryear/N15030/2011?page=2&per_page=100   100
4     N15030 V150115G0R02          2011         62.1             NA             NA http://api.kolada.se/v1/ou/data/peryear/N15030/2011?page=2&per_page=100   100
5     N15030 V150117G0R01          2011         84.8             NA             NA http://api.kolada.se/v1/ou/data/peryear/N15030/2011?page=2&per_page=100   100
6     N15030 V150117G0R02          2011         76.4             NA             NA http://api.kolada.se/v1/ou/data/peryear/N15030/2011?page=2&per_page=100   100
```
