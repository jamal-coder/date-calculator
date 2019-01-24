#!/bin/bash

############################################################################################################################
# Script : caldate.sh
# Version: 1.00 Beta
# Author : Jamal Khan
# Purpose: This script perform two functions 1) Calculate difference of two dates, 2) Calculate Future date by adding days.
############################################################################################################################
#---------------------- Variables ----------------------------
greenbold="\033[1;32m"
flashred="\033[5;31m"
normal="\033[0m"

#---------------------- Functions ----------------------------
function wait {
	echo -en $greenbold"\n\n Wrong selection,\n Select between [1-3],\n Press "$normal$flashred"<ENTER>"$normal$greenbold" to proceed.."$normal
	read  dummy
}
# years function takes input of years
function years {
	year=0
	while [[ ! $year =~ [0-9]{4} ]]; do
		read -p "Enter year [nnnn]: " year
	done
	echo $year
}

# months function takes input of months
function months {
	month=0
	while [[ $month -lt 1 || $month -gt 13 ]]; do
		read -p "Enter month [nn]: " month
	done
	echo $month
}

# days function takes input of days
function days {
	day=0
		
	while [[ $day -lt 1 || $day -gt 31  ]]; do
		read -p "Enter day [nn]: " day
		
		case $1 in
			2)
				leap=$(( $2 % 4 ))

				case $leap in
					0)
						if [[ $day -lt 1 || $day -gt 29 ]]; then
							day=0
						fi
						;;
					*)
						if [[ $day -lt 1 || $day -gt 28 ]]; then
							day=0
						fi
						;;
				esac
				;;
			4|6|9|11)
				if [[ $day -lt 1 || $day -gt 30 ]]; then
					day=0
				fi
				;;
		esac
	done
	echo $day
}

# display function has two options when it is called with 1 as first argument it displayes three lines
# However, when it is called with 2 it displays only one line
function display {
	if [[ $1 -eq 1 ]]; then
		echo -e "Status\t\tDay\tMonth\tYear"
		echo -e "Current\t\t$2\t$3\t$4"
		echo -e "Previous\t$5\t$6\t$7"
	elif [[ $1 -eq 2 ]]; then
		echo -e "Difference\t$2\t$3\t$4"
	fi
}

#---------------------- Main Program ----------------------------
while true; do
	clear
	echo -e $greenbold" Main Menu"$normal
	echo -e "\n 1 <--> Dates Difference"
	echo " 2 <--> Future Date"
	echo -e " 3 <--> Quit\n"
	read -p " Enter your Selection [1-3] : " select 
	case $select in
		1)
			while true; do
				while true; do
					clear

					echo "Enter previous date"
					preyear=$(years)
					premonth=$(months)
					preday=$(days $premonth $preyear)


					echo "Enter current date"
					curyear=$(years)	
					curmonth=$(months)
					curday=$(days $curmonth $curyear)

					clear

					echo "You have entered the following information"
					echo "-------------------------------------"
					display 1 $curday $curmonth $curyear $preday $premonth $preyear
					echo "-------------------------------------"
					echo -ne "\nIs this information correct [Y/N]: "
					read ans

					case $ans in
						[Yy]|[YESyes])
							break;;
					esac
				done
				clear

				# Here we will do calculation

				# In day calculation first we will check whehter the current day is less than the previous day
				# if so then we will add number of days based on the current month and current year speciall in the month of February
				if [[ $curday -lt $preday ]]; then
					case $curmonth in
						1|3|5|7|8|10|12)	
							curday=$(( curday + 31 ));;
						2)
							leap=$(( curyear % 4 ))

								case $leap in
									0)	curday=$(( curday + 29 ));;
									*)  curday=$(( curday + 28 ));;
								esac
								;;
						4|6|9|11)
							curday=$(( curday + 30 ));;	
					esac
					# after adding days in current day one is minused from current month
					curmonth=$(( curmonth - 1 ))
				fi
				# After confirmation and addtion of further days finally the difference of days are stored in variable diffday
				diffday=$(( curday - preday ))

				# if current month is less then previous month then 12 is added to the current month
				# and one is subtracted from current year
				if [[ $curmonth -lt $premonth ]]; then
					curmonth=$(( curmonth + 12 ))
					curyear=$(( curyear - 1 ))
				fi

				# After confirmation and addtion of further months finally the difference of months is stored in variable diffmonth
				diffmonth=$(( curmonth - premonth ))

				# And finally the difference of current year and previous year is stored in varialble diffyear
				diffyear=$(( curyear - preyear ))

				#Finally dispaly function is called with 2 for single line display
				echo "-------------------------------------"
					display 1 $curday $curmonth $curyear $preday $premonth $preyear
				echo "-------------------------------------"
				display 2 $diffday $diffmonth $diffyear
				echo "-------------------------------------"

				echo -ne "Press [Q or q] to quit to Main Menu: "
				read choice

				if [[ $choice = "Q" || $choice = "q" ]]; then
					break
				fi

			done
			;;
		2)
			# Taking input from user for the start of the day
			while true; do
				clear
				while true; do
					while [[ $sday -lt 1 || $sday -gt 31 ]]; do
						read -p " Enter day            : " sday
					done
					while [[ $smonth -lt 1 || $smonth -gt 12 ]]; do
						read -p " Enter Month          : " smonth
					done
					while [[ ! $syear = [0-9][0-9][0-9][0-9] ]]; do
						read -p " Enter Year           : " syear
					done
					leap=$(( syear % 4 ))
					if [[ $smonth -eq 2 && $leap -eq 0 && $sday -gt 29 ]]; then
						echo " A leap years February can't be more then 29 days"
						sday=0
						continue
					fi
					if [[ $smonth -eq 2 && $leap -ne 0 && $sday -gt 28 ]]; then
						echo " February can't have more then 28 days"
						sday=0
						continue
					fi
					while [[ $adays -lt 1 ]]; do
						read -p " How many days to add : " adays
					done
					clear
					echo -e "\n Date : $sday/$smonth/$syear"
					echo -e " Days to be added : $adays\n"
					read -p " Is this correct [Y-N] : " choice 
					if [[ $choice = [yY] ]]; then
						break
					else
						sday=0
						smonth=0
						syear=0
						adays=0
						continue
					fi
				done
				# here calcluation will be done
				rdays=$adays
				rmonth=$smonth
				ryear=$syear

				while true; do
					case $rmonth in
							1|3|5|7|8|10|12)	mdays=31;;
							4|6|9|11) 			mdays=30;;
							2)					if [[ $leap -eq 0 ]]; then
													mdays=29
												else
													mdays=28
												fi;;
					esac
					if [[ $rdays -eq $adays ]]; then
						mdays=$(( mdays - sday ))
					fi
					if [[ $rdays -le $mdays ]]; then
						rdays=$(( sday + rdays ))
						break
					else
						rdays=$(( rdays - mdays ))	
					fi
					(( rmonth++ ))
					if [[ $rmonth -gt 12 ]]; then
						rmonth=1
						(( ryear++ ))
					fi
				done

				echo -e "\033[1;32m\n Due date  : $rdays/$rmonth/$ryear\033[0m"
				echo -en "\n Another try [N] : "
				read choice
				if [[ $choice = [Nn] ]]; then
					break
				else
					sday=0
					smonth=0
					syear=0
					adays=0
					continue
				fi
			done
			;;
		3)
			clear
			echo -e $greenbold"\n\n Allah Hafiz\n\n"$normal
			break
			;;
		*)
			wait
			;;
	esac
done
