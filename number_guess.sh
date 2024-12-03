#!/bin/bash

PSQL="psql -U freecodecamp -d number_guess -t --no-align -c"

NL_ECHO() {
  local INPUT="$1"
  if [[ $INPUT ]]
  then
    echo -e "\n$INPUT"
  fi
}

# Ask for username
NL_ECHO "Enter your username:"
while [[ -z $USERNAME || ${USERNAME:22} ]]
do
  if [[ $USERNAME ]]
  then
    NL_ECHO "Enter a valid username (<= 22 characters)"
  fi
  read USERNAME
done

# query based on username
USER="$($PSQL "SELECT username,num_games,best_game FROM users WHERE username='$USERNAME'")"
# if no existing user,
if [[ -z $USER ]]
then
  # welcome message
  NL_ECHO "Welcome, $USERNAME! It looks like this is your first time here."
  NL_ECHO "$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")"
else
  # else display statistics
  echo "$USER" | while IFS="|" read USERNAME NUM BEST
  do
    NL_ECHO "Welcome back, $USERNAME! You have played $NUM games, and your best game took $BEST guesses."
  done
fi
# generate random

# init user guess, guess count

# while user guess !== random || user guess IS NOT int, update count

# when user guess === random

# if no existing user, insert new data

# if user, update num_games and, if necessary, best_game

# echo success message