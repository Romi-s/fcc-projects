#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
# Script logic goes here

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Query the database
  ELEMENT_DATA=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE elements.atomic_number::text = '$1' OR symbol = '$1' OR name = '$1'")

  # Check if element was found
  if [[ -z $ELEMENT_DATA ]]
  then
    echo "I could not find that element in the database."
  else
    # Parse the data and print the formatted string
    echo "$ELEMENT_DATA" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi