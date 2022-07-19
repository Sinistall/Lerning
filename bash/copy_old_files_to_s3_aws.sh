#!/bin/bash

dir="/home/andriy/scripts"
list=`ls "$dir/"`

for file in $list
do
	date_file=`date +"%Y%m%d" -r $dir/$file`
	num_month=${date_file:4:2}
	expired_month_int=$(( $num_month + 2 ))
	
	if [[ $expired_month_int -lt 10 ]]
	then
		expired_month="0$expired_month_int"
	else
		expired_month=$expired_month_int
	fi

	expired_date="${date_file::4}$expired_month${date_file:6}"
	date_now=`date +"%Y%m%d"`
	if [[ $date_now -ge $expired_date ]]
	then
		aws s3 cp $dir/$file s3://bucket-for-me-67276/
	fi
done
