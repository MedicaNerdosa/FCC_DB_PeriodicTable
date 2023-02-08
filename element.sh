#!/bin/bash
#check the first argument
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  #input evaluation
  #check if input is a number or not and search for the atomic number accordingly
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1' OR symbol='$1';")
  fi
  #if atomic number is empty
  if [[ -z $ATOMIC_NUMBER ]]
  then
    #promt not found
    echo "I could not find that element in the database."
  else
    INFO=$($PSQL "SELECT name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types USING(type_id) WHERE elements.atomic_number=$ATOMIC_NUMBER;")
    echo $INFO | while IFS='|' read NAME SYMBOL TYPE MASS MELT BOIL
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi