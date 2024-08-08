if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  #read ELEMENT
else
  ELEMENT=$1
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  SQL_ELEMENT=''
  if [[ $ELEMENT =~ ^-?[0-9]+$ ]]
  then
    SQL_ELEMENT=$($PSQL "SELECT * FROM properties p INNER JOIN elements e USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ELEMENT")
  else
    SQL_ELEMENT=$($PSQL "SELECT * FROM properties p INNER JOIN elements e USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$ELEMENT' OR name='$ELEMENT'")
  fi

  if [[ -z $SQL_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$SQL_ELEMENT" | sed -e 's/|/ | /g' | while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR SYMBOL BAR NAME BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
