//
//  UBDate.m
//  Unison Brain
//
//  Created by Kyle Warren on 2/5/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "UBDate.h"

@implementation UBDate

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromDateMedium:(NSDate *)date
{
    return [self stringFromDate:date format:@"MMM d, HH:mm"];
}


+ (NSString *)stringFromDateShort:(NSDate *)date
{
    return [self stringFromDate:date format:@"MMM d"];
}

+ (NSNumber *)toNum:(NSDate *)time
{
    return [NSNumber numberWithInteger:[time timeIntervalSince1970]];
}

+ (BOOL)wasThisWeek:(NSDate *)date{
    
    int timeInt = [date timeIntervalSinceDate:date];
    if (timeInt<605000) return YES;
    else return NO;
    
}

+ (BOOL)wasLastTwoWeeks:(NSDate *)date{
    
    int timeInt = [date timeIntervalSinceDate:date];
    if (timeInt<1209600) return YES;
    else return NO;
    
    
}


@end
