//
//  TimeUtil.c
//  FetionUtil
//
//  Created by Born on 14-4-2.
//  Copyright (c) 2014年 FetionUtil. All rights reserved.
//

#include "TimeUtil.h"
#include <sys/time.h>

void log_time_now(struct log_time *time)
{
    struct  timeval the_time;
    time_t sec = 0;
    suseconds_t msec = 0;
	int rc = gettimeofday(&the_time, NULL);
	if (!rc)
	{
		sec = the_time.tv_sec;
        msec = the_time.tv_usec;
    }
    
    struct tm* tm_time;
	tm_time = localtime(&sec);
	time->year = tm_time->tm_year + 1900;
	time->mon = tm_time->tm_mon+1;
	time->day = tm_time->tm_mday;
	time->hour = tm_time->tm_hour;
	time->min = tm_time->tm_min;
	time->sec = tm_time->tm_sec;
	time->wday = tm_time->tm_wday;
	time->msec = msec;
}

NSString* log_time_now_str()
{
    struct log_time time;
    log_time_now(&time);
    NSString * timeStr = [NSString stringWithFormat:@"%0.4d-%0.2d-%0.2d %0.2d:%0.2d:%0.2d.%0.3d", time.year,time.mon,time.day,time.hour,time.min,time.sec,time.msec/1000];
    return timeStr;
}
