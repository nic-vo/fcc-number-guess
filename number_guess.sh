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
else
  # else display statistics
  while IFS="|" read CURRENT_USERNAME NUM BEST
  do
    NUM_GAMES=$NUM
    BEST_GAME=$BEST
    NL_ECHO "Welcome back, $USERNAME! You have played $NUM games, and your best game took $BEST guesses."
  done < <(echo "$USER")
fi

NL_ECHO "Guess the secret number between 1 and 1000:"
# generate random
TARGET=$(($RANDOM % 1000 + 1))
# init user guess, guess count
GUESSES=0
CURRENT_GUESS=$(($RANDOM % 1000 + 1))
while [[ $TARGET = $CURRENT_GUESS ]]
do
  CURRENT_GUESS=$(($RANDOM % 1000 + 1))
done
# while user guess !== random || user guess IS NOT int, update count

# when user guess === random

# if no existing user, insert new data

# if user, update num_games and, if necessary, best_game

# echo success message