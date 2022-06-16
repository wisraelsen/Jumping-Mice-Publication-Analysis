#!/usr/bin/awk

# script to compile motion information from cleaned expedata export file, adds up activity data for each day, split by light cycle
# requires input file with following columns: 1 - date, 2 - elapsed time for that date in seconds, 3 - motion sensor voltage (~3.3 = motion, ~0 = no motion)
# will use 1.5V as cutoff

BEGIN {
getline;
flag = 0;
motion = 0;
motion_count = 0;
start_date = "Start";
end_date = "";
}

{
if($2<56160){
	flag = 0;   #reset flag from previous night
	if($3 == "NA"){      # no motion recorded
	motion = motion;
	motion_count = motion_count;
	
	}
	else if($3>1.5){     # motion detected
	motion = motion + 1;
	motion_count = motion_count + 1;
	}
	else {               # no motion detected
	motion = motion;
	motion_count = motion_count +1;
	}
	#print start_date, motion, motion_count
	
}
else if($2>=56160 && flag == 0){
	flag = 1; # set flag so only report once for today
	end_date = $1;   # set end date
	print start_date, end_date, motion, motion_count;  # report for previous day 
	start_date = $1;  # start this day as new day
	motion = 0;	  # reset motion detected
	motion_count = 0; # reset motion_count

        if($3 == "NA"){      # no motion recorded
        motion = motion;
        motion_count = motion_count;

        }
        else if($3>1.5){     # motion detected
        motion = motion + 1;
        motion_count = motion_count + 1;
        }
        else {               # no motion detected
        motion = motion;
        motion_count = motion_count +1;
        }
}

else if($2>=56160 && flag == 1){    # keep recording, don't report until tomorrow
        start_date = $1;  # start this day as new day

        if($3 == "NA"){      # no motion recorded
        motion = motion;
        motion_count = motion_count;

        }
        else if($3>1.5){     # motion detected
        motion = motion + 1;
        motion_count = motion_count + 1;
        }
        else {               # no motion detected
        motion = motion;
        motion_count = motion_count +1;
        }
}


}
END{
end_date = $1;
print start_date, end_date, motion, motion_count, "END!";  # report final data at end of record 
}
