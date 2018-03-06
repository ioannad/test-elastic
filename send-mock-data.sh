#!/bin/sh

I=0
while read p; do
  I=`expr $I + 1`
  echo "Adding $p"
  curl -XPUT "localhost:9200/patient_data/doc/${I}?pretty" -H 'Content-Type: application/json' -d "${p}"
done <mock-data

echo " "
echo "'Schlechtes' Dokument schicken klappt nicht."
echo " "
echo 'Versuch zu schicken: { "id" : 12, "pain-before" : 6.4, "pain-after" : 2, "complications" : false, "op_date" : "2011-01-13"}'


curl -XPOST "localhost:9200/patient_data/doc" -H 'Content-Type: application/json' -d '
{ "patient-id" : 12, "pain-before" : 6.4, "pain-after" : "foo", "complications" : false, "op_date" : "2011-01-13"}'
