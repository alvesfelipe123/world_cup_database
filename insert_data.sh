#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# WINNER=$($PSQL "SELECT * FROM teams WHERE name = 'Brazil' ")


#lendo o arquivo para pegar os times
tail -n +2 "games.csv" | while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
    #inserindo os times na tabela teams
    WINNER=$($PSQL "SELECT * FROM teams WHERE name = '$winner'")
    if [[ -z $WINNER ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$winner') ")
    fi
    
    OPPONENT=$($PSQL "SELECT * FROM teams WHERE name = '$opponent'")
    if [[ -z $OPPONENT ]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent') ")
    fi

    #pegando os team_id na tabela teams
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")

    #inserindo os jogos na tabela games
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$year', '$round', '$WINNER_ID', '$OPPONENT_ID', '$winner_goals', '$opponent_goals')")
    
done
