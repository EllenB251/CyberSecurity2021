#!/bin/bash

# $1 is the filename including the date in 4 digits (e.g. 0310)
# $2 is the hour (e.g. 5)
# $3 is AM or PM
# $4 is the first word of the game title (BlackJack, Roulette, or Texas)

if [ \( "$4" = "BlackJack" \) -o \(  "$4" = "Blackjack" \) -o \( "$4" = "blackjack" \) -o \( "$4" = "BLACKJACK" \) ]; then 
awk '{print $1, $2, $3, $4}' ./$1* | grep $2 | grep -iw $3
fi

if [ \( "$4" = "Roulette" \) -o \( "$4" = "roulette" \) -o \( "$4" = "ROULETTE" \) ]; then
awk '{print $1, $2, $5, $6}' ./$1* | grep $2 | grep -iw $3
fi

if [ \( "$4" = "Texas" \) -o \( "$4" = "texas" \) -o \( "$4" = "TEXAS" \) ]; then
awk '{print $1, $2, $7, $8}' ./$1* | grep $2 | grep -iw $3
fi
