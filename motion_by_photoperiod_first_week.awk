#!/usr/bin/awk -f

# this version for long days of first week only; use version of input data file that only extends to the end of the first week.
# script to compile motion information from cleaned expedata export file, adds up activity data for each day, split by light cycle
# requires full input file with following columns: 1) date, 2) elapsed time for that date in seconds, 3-13) sensor voltages (~3.3 = motion, ~0 = no motion) and other sensors, 14) Light or Dark Cycle (not needed in script)
# will use 1.5V as cutoff for motion sensor voltage
# have to code in the column numbers for each sensor of interest, do this using col variable in BEGIN


BEGIN {
OFS="\t";
col = 10;   ##### set this to choose which column to process
flag = 0;
motion_light = 0;
motion_count_light = 0;
motion_dark = 0;
motion_count_dark = 0;
start_date = "Start";
end_date = "";
prevseconds = 0;
prevdate = 0;
print "start_date", "end_date", "motion_dark", "motion_count_dark", "motion_light", "motion_count_light" "total_motion", "total_motion_count";
getline;
}

{
if((($2 - prevseconds)%300 != 0) && prevdate != $1){   # check for transition between recordings, if so, report and start new day; modulo condition is required to make sure don't start new day at midnight
	if($2>=65160){flag = 1}; # set flag so only report once for today, but only needed if it's after dark in evening. This seconds cutoff is for onset of dark cycle.
        end_date = $1;   # set end date
        print start_date, prevdate, motion_dark, motion_count_dark, motion_light, motion_count_light, motion_dark + motion_light, motion_count_dark + motion_count_light, $2, prevseconds;  # report for previous day
        start_date = $1;  # start this day as new day
        motion_light = 0;         # reset motion detected
        motion_count_light = 0; # reset motion_count
        motion_dark = 0;        # reset
        motion_count_dark = 0;  #reset
	prevseconds = $2;
	prevdate = $1;

        if($(col) == "NA"){      # no motion recorded
        motion_dark = motion_dark;
        motion_count_dark = motion_count_dark;

        }
        else if($(col)>1.5){     # motion detected
        motion_dark = motion_dark + 1;
        motion_count_dark = motion_count_dark + 1;
        }
        else {               # no motion detected
        motion_dark = motion_dark;
        motion_count_dark = motion_count_dark +1;
        }
}

else if($2<7560){	# this seconds cutoff is for onset of light cycle;
	prevseconds = $2
	prevdate = $1;
	flag = 0;   #reset flag from previous night
	if($(col) == "NA"){      # no motion recorded
	motion_dark = motion_dark;
	motion_count_dark = motion_count_dark;
	
	}
	else if($(col)>1.5){     # motion detected
	motion_dark = motion_dark + 1;
	motion_count_dark = motion_count_dark + 1;
	}
	else {               # no motion detected
	motion_dark = motion_dark;
	motion_count_dark = motion_count_dark +1;
	}
	#print start_date, motion, motion_count
	
}

else if($2>=7560 && $2<65160){		# seconds cutoffs are for time while lights are on
	prevseconds = $2;
	prevdate = $1;
        flag = 0;   #reset flag from previous night
	if($(col) == "NA"){      # no motion recorded
        motion_light = motion_light;
        motion_count_light = motion_count_light;

        }
        else if($(col)>1.5){     # motion detected
        motion_light = motion_light + 1;
        motion_count_light = motion_count_light + 1;
        }
        else {               # no motion detected
        motion_light = motion_light;
        motion_count_light = motion_count_light +1;
        }
        #print start_date, motion, motion_count

}

else if($2>=65160 && flag == 0){   # end day at lights out and report
	prevseconds = $2;
	prevdate = $1;
	flag = 1; # set flag so only report once for today
	end_date = $1;   # set end date
	print start_date, prevdate, motion_dark, motion_count_dark, motion_light, motion_count_light, motion_dark + motion_light, motion_count_dark + motion_count_light;  # report for previous day 
	start_date = $1;  # start this day as new day
	motion_light = 0;	  # reset motion detected
	motion_count_light = 0; # reset motion_count
	motion_dark = 0;	# reset
	motion_count_dark = 0; 	#reset

        if($(col) == "NA"){      # no motion recorded
        motion_dark = motion_dark;
        motion_count_dark = motion_count_dark;

        }
        else if($(col)>1.5){     # motion detected
        motion_dark = motion_dark + 1;
        motion_count_dark = motion_count_dark + 1;
        }
        else {               # no motion detected
        motion_dark = motion_dark;
        motion_count_dark = motion_count_dark +1;
        }
}

else if($2>=65160 && flag == 1){    # keep recording, don't report until tomorrow
	prevseconds = $2;
	prevdate = $1;
        start_date = $1;  # start this day as new day

        if($(col) == "NA"){      # no motion recorded
        motion_dark = motion_dark;
        motion_count_dark = motion_count_dark;

        }
        else if($(col)>1.5){     # motion detected
        motion_dark = motion_dark + 1;
        motion_count_dark = motion_count_dark + 1;
        }
        else {               # no motion detected
        motion_dark = motion_dark;
        motion_count_dark = motion_count_dark +1;
        }
}


}
END{
end_date = $1;
print start_date, prevdate, motion_dark, motion_count_dark, motion_light, motion_count_light, motion_dark + motion_light, motion_count_dark + motion_count_light;  # report final data at end of record 
#print "End";
}
