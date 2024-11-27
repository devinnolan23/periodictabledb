#!/bin/bash

if [[ -z $1 ]]
  then
  echo Please provide an element as an argument.
  else 

  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  
  

  if [[ $1 =~ ^[0-9]+$ ]]
   then
    #check_atomic_number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
   elif [[ $1 =~ ^[A-Z][a-z]$ ]] || [[ $1 =~ ^[A-Z]$ ]]
   then
    #check_symbols
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
   else
    #check name
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  fi

  if [[ -z $ATOMIC_NUMBER ]] 
  then
    echo -e "I could not find that element in the database."
  else
  #format and print relative info using atomic number 
  #info in order: atomic_number, Name, Symbol, Type, Mass, Melting point, Boiling point
  
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi


