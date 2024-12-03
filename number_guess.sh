#!/bin/bash

PSQL="psql -U freecodecamp -d number_guess -t --no-align -c"

# Ask for username
echo "Enter your username:"
while [[ -z $USERNAME || ${USERNAME:22} ]]
do
  if [[ $USERNAME ]]
  then
    echo "Enter a valid username (<= 22 characters)"
  fi
  read USERNAME
done

# query based on username
USER="$($PSQL "SELECT username,num_games,best_game FROM users WHERE username='$USERNAME'")"
# if no existing user,
if [[ -z $USER ]]
then
  # welcome message
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  # else display statistics
  while IFS="|" read CURRENT_USERNAME NUM BEST
  do
    NUM_GAMES=$NUM
    BEST_GAME=$BEST
    echo "Welcome back, $USERNAME! You have played $NUM games, and your best game took $BEST guesses."
  done < <(echo "$USER")
fi

echo "Guess the secret number between 1 and 1000:"
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
while [[ $TARGET != $CURRENT_GUESS ]]
do
  echo Target: $TARGET
  read CURRENT_GUESS
  GUESSES=$(($GUESSES + 1))
  if [[ ! $CURRENT_GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi
  if [[ $CURRENT_GUESS -lt $TARGET ]]
  then
    echo "It's higher than that, guess again:"
    continue
  elif [[ $CURRENT_GUESS -gt $TARGET ]]
  then
    echo "It's lower than that, guess again:"
    continue
  else
    continue
  fi
done

# when user guess === random
if [[ -z $NUM_GAMES ]]
then
  NUM_GAMES=1
else
  NUM_GAMES=$(($NUM_GAMES + 1))
fi

if [[ -z $BEST_GAME || $BEST_GAME > $GUESSES ]]
then
  BEST_GAME=$GUESSES
fi

if [[ $USER ]]
then
  # if user, update num_games and, if necessary, best_game
  RESULT="$($PSQL "UPDATE users SET best_game=$BEST_GAME, num_games=$NUM_GAMES WHERE username='$USERNAME';")"
else
  # if no existing user, insert new data
  RESULT="$($PSQL "INSERT INTO users(username,num_games,best_game) VALUES('$USERNAME', $NUM_GAMES, $BEST_GAME);")"
fi

# echo success message
echo "You guessed it in $GUESSES tries. The secret number was $TARGET. Nice job!"
