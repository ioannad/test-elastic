#!/bin/sh

x=$1
if [ "$x" == "" ]
then 
  x=0
fi


echo "-----------------------"
echo "Elastisearch Tech Talk "
echo "-----------------------"

echo "WARNING: Will now delete the index patient_data, press CTL-C to abort."

sleep 5

curl -X DELETE 'http://localhost:9200/patient_data'



sleep $x

echo ""
echo "-----------------------"
echo "Create a mapping type to (sort of) define the field types:"
echo "-----------------------"

sleep $x

curl -XPUT 'localhost:9200/patient_data?pretty' \
           -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "doc": { 
      "properties": { 
        "patient-id":    { "type": "integer"  }, 
        "pain-before":     { "type": "integer"  }, 
        "pain-after":      { "type": "integer" },	  
        "complications" : { "type" : "boolean" }, 
        "op_date" :  {
          "type":   "date", 
          "format": "yyyy-MM-dd"
        },
        "comments" : { "type" : "text" },
        "location" : { "type" : "geo_point" },
        "bloodpressure-sys" : { "type" : "float" }
      }
    }
  }
}'

sleep $x

echo "-----------------------"
echo "Will now send some mock data fitting the mapping just defined above."
echo "-----------------------"

sleep $x

while read p; do
  echo "Adding $p"
  curl -XPOST "localhost:9200/patient_data/doc/${I}?pretty" -H 'Content-Type: application/json' -d "${p}"
done <mock-data

sleep $x 

echo "-----------------------"
echo "Attempting to send a document with fields of a (very) wrong type won't work (text instead of integer)."
echo "-----------------------"

sleep $x

BAD_DOC='{ "patient-id" : 12, "pain-before" : 6.4, "pain-after" : "foo", "complications" : false, "op_date" : "2011-01-13"}'

NOT_SO_BAD_DOC='{ "patient-id" : 12, "pain-before" : 6.4, "pain-after" : 7.8, "complications" : false, "op_date" : "2011-01-13"}' 

curl -XPOST "localhost:9200/patient_data/doc?pretty" -H 'Content-Type: application/json' -d "${BAD_DOC}"

sleep $x 

echo "-----------------------"
echo "Attempting to send a document with fields of a slightly wrong type will work though (float instead of integer)."
echo "-----------------------"

sleep $x

curl -XPOST "localhost:9200/patient_data/doc?pretty" -H 'Content-Type: application/json' -d "${NOT_SO_BAD_DOC}"

sleep $x

echo "-----------------------"
echo "Check out the mapping type"
echo "-----------------------"

sleep $x

curl -XGET 'localhost:9200/patient_data/_mapping/doc?pretty'


echo "-----------------------"
echo "PS: if this went too fast, execute:"
echo 'sh send-mock-data $x'
echo 'where $x the amount of seconds to wait between each step.'
