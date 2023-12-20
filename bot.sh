# !/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

GETSYM=$($PSQL "SELECT symbol FROM elements WHERE name = '$1';")

if [[ $1 -ge 1 && $1 -le 10 ]]
then 

  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1;")

  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1;")

  TYPE=$($PSQL "SELECT type FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number = $1;")

  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1;")

  MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1;")

  BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1;")

  echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."

elif [[ $1 =~ ^(H|Be|Li|B|C|N|O|F|Ne|He)$ || $GETSYM =~ ^(H|Be|Li|B|C|N|O|F|Ne|He)$ ]]
then
  
  NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1' OR symbol = '$GETSYM';")

  NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR symbol = '$GETSYM';")

  TYPE=$($PSQL "SELECT type FROM elements FULL JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$1' OR symbol = '$GETSYM';")

  MASS=$($PSQL "SELECT atomic_mass FROM elements FULL JOIN properties USING(atomic_number) WHERE symbol = '$1' OR symbol = '$GETSYM';")

  MELT=$($PSQL "SELECT melting_point_celsius FROM elements FULL JOIN properties USING(atomic_number) WHERE symbol = '$1' OR symbol = '$GETSYM';")

  BOIL=$($PSQL "SELECT boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) WHERE symbol = '$1' OR symbol = '$GETSYM';")

  if [[ -z $GETSYM ]]
  then
    
    echo "The element with atomic number $NUMBER is $NAME ($1). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  
  else

    echo "The element with atomic number $NUMBER is $NAME ($GETSYM). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."

  fi

elif [[ ! -z $1 ]]
then
    
  echo "I could not find that element in the database."

else
 
  echo "Please provide an element as an argument."

fi
