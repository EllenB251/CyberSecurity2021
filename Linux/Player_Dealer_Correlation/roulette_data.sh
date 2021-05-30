#!/bin/bash

# $1 is the filename containing the date in 4 digits (e.g. 0310)

if [ \( $1 = "0310" \) -o \( $1 = "0312" \) ]; then
awk '{print $1, $2, $5, $6}' ./$1* | grep '05:00:00 AM' >> Dealers_working_during_losses
awk '{print $1, $2, $5, $6}' ./$1* | grep '08:00:00 AM' >> Dealers_working_during_losses
awk '{print $1, $2, $5, $6}' ./$1* | grep '02:00:00 PM' >> Dealers_working_during_losses
awk '{print $1, $2, $5, $6}' ./$1* | grep '08:00:00 PM' >> Dealers_working_during_losses
awk '{print $1, $2, $5, $6}' ./$1* | grep '11:00:00 PM' >> Dealers_working_during_losses
fi 

if  [ $1 = "0315" ]; then
awk '{print $1, $2, $5, $6}' ./$1* | grep '05:00:00 AM' >> Dealers_working_during_losses
awk '{print $1, $2, $5, $6}' ./$1* | grep '08:00:00 AM' >> Dealers_working_during_losses
awk '{print $1, $2, $5, $6}' ./$1* | grep '02:00:00 PM' >> Dealers_working_during_losses
fi
