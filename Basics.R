# Neo4j
#
library(RJSONIO)
library(RCurl)

param.list = list(a='b') # I don't yet know how to use parameters

query.neo4j = function(query.string, param.list) {
  # query.string = "MATCH (n) return n"
  # query.string = paste("CREATE",
  fromJSON(
    getURL("http://localhost:7474/db/data/cypher", 
         customrequest='POST', 
         httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(query=query.string,
                                params=param.list))
         )
    )
}

# Clear all nodes and edges/relationships from database
the.result = 
  query.neo4j(
    paste("START n=node(*)",
          "OPTIONAL MATCH n-[r]-()",
          "DELETE n, r;"
          ),
    param.list)

the.result = 
  query.neo4j("MATCH (n) return n",
              param.list)

# Create a node in the database
query.neo4j(
  paste("CREATE",
        "(a {name : 'Andres', age: 28, dog: 'Rufus' })",
        "RETURN a"),
  param.list)
query.neo4j(
  paste("CREATE",
        "(a {name : 'Emil', age: 30, cat: 'Mittens' })",
        "RETURN a"),
  param.list)
query.neo4j(
  paste("CREATE",
        "(a {name : 'Max', age: 34, snake: 'Sam' })",
        "RETURN a"),
  param.list)

# Get all nodes from database (both commands give identical results)
the.result = 
  query.neo4j("START n=node(*) RETURN n",
              param.list)
the.result = 
  query.neo4j("MATCH (n) return n",
              param.list)

length(the.result$data)
names(the.result$data)
length(the.result$data[[1]])
names(the.result$data[[1]])
the.result$data[[1]]
the.result$data[[1]][[1]]
the.result$data[[1]][[1]]$data
class(the.result$data[[1]][[1]]$data)
as.data.frame(the.result$data[[1]][[1]]$data)

result.dataframes = 
  lapply(the.result$data, 
         function(x) { 
           as.data.frame(x[[1]]$data)})
result.dataframes

merge(result.dataframes[[1]], 
      result.dataframes[[3]], 
      all=TRUE)

rec.merge = 
  function(x) { 
    n = length(x); 
    if (n==1) { data.frame(x) } 
    else { merge(x[[1]], 
                 rec.merge(x[2:n]),
                 all=TRUE)}}
rec.merge(result.dataframes)



### IGNORE THE REST ###
curl -H Accept:application/json \
-H Content-Type:application/json \
-X POST \
-d '{"query" : "match (one:Person)-->(two:Person) return one.name, two.name"}' \
http://localhost:7474/db/data/cypher

POST = "query=match (one:Person {name:\"Jae\"}) return one.name"

library(RCurl)
library(RJSONIO)
h = basicTextGatherer()
h$reset()

URL = "http://ledger.bentley.edu:7474/db/data/cypher"
POST = "query=match (one:Person) return one.name"
curlPerform(url=URL, postfields=POST, writefunction=h$update)
fromJSON(h$value())$data

fromJSON(
  getURL("http://ledger.bentley.edu:7474/db/data/cypher", 
         customrequest='POST', 
         httpheader=c('Content- Type'='application/json'),
         postfields=toJSON(list(query="S1",params=list(pathway="S2")))
  )
)

