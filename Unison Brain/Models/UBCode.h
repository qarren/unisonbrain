//
//  UBCode.h
//  Unison Brain
//
//  Created by Kyle Warren on 1/30/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "UBModel.h"
#import "UBSubject.h"

@class UBBreach, UBCodeScore, UBSubject, UBCodeType;

@interface UBCode : UBModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSSet *breaches;
@property (nonatomic, retain) NSSet *codeScores;
@property (nonatomic, retain) UBSubject *subject;
@property (nonatomic, retain) UBCodeType * codeType;


@end

@interface UBCode (CoreDataGeneratedAccessors)

- (void)addBreachesObject:(UBBreach *)value;
- (void)removeBreachesObject:(UBBreach *)value;
- (void)addBreaches:(NSSet *)values;
- (void)removeBreaches:(NSSet *)values;

- (void)addCodeScoresObject:(UBCodeScore *)value;
- (void)removeCodeScoresObject:(UBCodeScore *)value;
- (void)addCodeScores:(NSSet *)values;
- (void)removeCodeScores:(NSSet *)values;

@end
