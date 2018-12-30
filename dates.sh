#!/bin/bash

#========== Functions ==========
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

#========== Main Program ==========
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

	echo -ne "Press [Q or q] to quit: "
	read choice

	if [[ $choice = "Q" || $choice = "q" ]]; then
		exit 0
	fi

done







