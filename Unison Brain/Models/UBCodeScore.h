//
//  UBCodeScore.h
//  Unison Brain
//
//  Created by Kyle Warren on 1/30/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "UBModel.h"


@class UBCode, UBConference;

@interface UBCodeScore : UBModel

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString *notion;
@property (nonatomic, retain) UBCode *code;
@property (nonatomic, retain) UBConference *conference;

+ (NSArray *)notions;

@end

