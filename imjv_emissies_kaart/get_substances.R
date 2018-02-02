library(SPARQL)

    
    # Step 1 - Set up preliminaries and define query
    # Define the endpoint
 #endpoint <- "http://lodomv-on-2.vm.cumuli.be:8100/imjv/sparql"
endpoint <- "http://rdfstoreomv-on-1.vm.cumuli.be:3030/rdfstoreomv/archive/query"
    
    # create query statement
query <- "
   PREFIX milieu: <https://id.milieuinfo.be/def#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    PREFIX http: <http://www.w3.org/2011/http#>
    PREFIX sdmx: <http://purl.org/linked-data/sdmx/2009/attribute#>
    PREFIX locn: <http://www.w3.org/ns/locn#>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    
    SELECT ?jaar ?stof ?hoeveelheid ?eenheid ?latitude ?longitude ?refgebied ?TX_MUNTY_DESCR_NL
    WHERE {GRAPH <urn:x-arq:UnionGraph>{
    ?subject a <http://purl.org/linked-data/cube#Observation> ;
    milieu:referentiegebied ?refgebied ;    
    milieu:hoeveelheid ?hoeveelheid ;
    sdmx:unitMeasure ?unit ;
    milieu:tijdsperiode ?jaar ;
    
    milieu:substantie ?substantie .
    FILTER ( ?hoeveelheid > 0 )
    ?substantie  skos:prefLabel ?s.
    ?refgebied a milieu:Emissiepunt ;
    milieu:exploitatie ?xtie ;
    geo:lat ?latitude ;
    geo:long ?longitude .
    ?unit skos:altLabel ?eenheid .
    BIND (STR(?s)  AS ?stof) 
    }
    SERVICE <http://lodcbbomv-on-1.vm.cumuli.be:8080/lodomv/repositories/cbb> {
    ?xtie locn:address ?adres .
    ?adres <http://www.w3.org/ns/locn#postName>  ?label.
    FILTER (lang(?label) = 'nl')
    BIND (STR(?label)  AS ?TX_MUNTY_DESCR_NL) 
    }
    }

"

    
    # Step 2 - Use SPARQL package to submit query and save results to a data frame
    qd <- SPARQL(endpoint,query)
    df <- qd$results
    #print(df, quote = TRUE, row.names = FALSE)
    full_table<-rbind(df)
    write.csv(full_table, file = "data/full_table2.csv")

