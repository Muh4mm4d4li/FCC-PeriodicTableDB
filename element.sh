#!/bin/bash
PSQL="psql -t -A -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

CHECK_DATA() {
  #if data is unknown
  if [[ -z $1 ]]; then
    echo "I could not find that element in the database."
  else
    echo $1 | while IFS='|' read ID NUM MASS MELT BOIL SYM NAME TYPE; do
      echo "The element with atomic number $NUM is $NAME ($SYM). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
}

#if an argument exists
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  #if it is a number
  if [[ $1 =~ ^[0-9]+$ ]]; then
    DATA=$($PSQL "SELECT * FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number=$1")
    CHECK_DATA "$DATA"
  else
    #if it is a name
    if [[ $1 =~ ^[a-zA-Z]{3,}$ ]]; then
      DATA=$($PSQL "SELECT * FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE name='$1'")
      CHECK_DATA "$DATA"
    else
      #get data by symbol
      DATA=$($PSQL "SELECT * FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE symbol='$1'")
      CHECK_DATA "$DATA"
    fi
  fi
fi
