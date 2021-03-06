//
//  UBBreach.h
//  Unison Brain
//
//  Created by Kyle Warren on 1/30/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "UBModel.h"


@class UBCode, UBContribution, UBPerson, UBSession, UBCodeType;

@interface UBBreach : UBModel

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) UBCodeType * codeType;
@property (nonatomic, retain) NSSet *codes;
@property (nonatomic, retain) NSSet *contributions;
@property (nonatomic, retain) NSSet *people;
@property (nonatomic, retain) UBSession *session;

@property (nonatomic) NSArray * sortedContributions;

- (NSString *)studentList;
- (NSString *)codeList;

@end

@interface UBBreach (CoreDataGeneratedAccessors)

- (void)addCodesObject:(UBCode *)value;
- (void)removeCodesObject:(UBCode *)value;
- (void)addCodes:(NSSet *)values;
- (void)removeCodes:(NSSet *)values;

- (void)addContributionsObject:(UBContribution *)value;
- (void)removeContributionsObject:(UBContribution *)value;
- (void)addContributions:(NSSet *)values;
- (void)removeContributions:(NSSet *)values;

- (void)addPeopleObject:(UBPerson *)value;
- (void)removePeopleObject:(UBPerson *)value;
- (void)addPeople:(NSSet *)values;
- (void)removePeople:(NSSet *)values;

@end
