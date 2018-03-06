#!/bin/sh

while read p; do
  echo "Adding $p"
  curl -XPOST "localhost:9200/patient_data/doc/${I}?pretty" -H 'Content-Type: application/json' -d "${p}"
done <mock-data

echo " "
echo "'Schlechtes' Dokument schicken klappt nicht."
echo " "

BAD_DOC='{ "patient-id" : 12, "pain-before" : 6.4, "pain-after" : "foo", "complications" : false, "op_date" : "2011-01-13"}'

echo "Versuch zu schicken ${BAD_DOC}"

curl -XPOST "localhost:9200/patient_data/doc" -H 'Content-Type: application/json' -d "${BAD_DOC}"

