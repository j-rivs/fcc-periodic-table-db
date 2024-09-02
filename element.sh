#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1

if [[ -z $INPUT ]]; then
  echo "Please provide an element as an argument."
  exit
fi

#check if atomic number
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  QUERY="SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
         FROM elements
         JOIN properties ON elements.atomic_number = properties.atomic_number
         JOIN types ON properties.type_id = types.type_id
         WHERE elements.atomic_number = $INPUT;"

# check if symbol
elif [[ $INPUT =~ ^[A-Za-z]{1,2}$ ]]; then
  QUERY="SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
         FROM elements
         JOIN properties ON elements.atomic_number = properties.atomic_number
         JOIN types ON properties.type_id = types.type_id
         WHERE elements.symbol = '$INPUT';"

# otherwise, assume a name
else
  QUERY="SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
         FROM elements
         JOIN properties ON elements.atomic_number = properties.atomic_number
         JOIN types ON properties.type_id = types.type_id
         WHERE elements.name = '$INPUT';"

fi

# execute query and store results
RESULT=$($PSQL "$QUERY")

if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  # Parse resultss into variables
  IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS <<< "$RESULT"
  # final echo result
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
fi
