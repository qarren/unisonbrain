//
//  UBSessionView.m
//  Unison Brain
//
//  Created by Kyle Warren on 2/1/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "UBSessionView.h"

#include "UBFunctions.h"

#import "UBSubject.h"
#import "UBCodeType.h"
#import "UBShadowView.h"


#define LEFT_WIDTH 790.0f
#define RIGHT_WIDTH (1024.0f - 790.0f)

@interface UBSessionView ()

@property (nonatomic) UILabel *selectorLabel;
@property (nonatomic) UIView *controlPanelBackground;
@property (nonatomic) BOOL shrunk;
@property (nonatomic) NSArray *subjects;
@property (nonatomic) UBShadowView *listBg;

@end

@implementation UBSessionView

@synthesize studentSelector = _studentSelector;
@synthesize listSelectView = _listSelectView;
@synthesize createBreach = _createBreach;
@synthesize changeDate = _changeDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _breachesView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        //_breachesView.backgroundView.opaque = YES;
        [self addSubview:_breachesView];
        
        _controlPanelBackground = [[UIView alloc] init];
        _controlPanelBackground.backgroundColor = [UIColor whiteColor];
        // we need a something better. this slows rendering.
        _controlPanelBackground.layer.shadowColor = [UIColor blackColor].CGColor;
        _controlPanelBackground.layer.shadowOpacity = 0.5f;
        _controlPanelBackground.layer.shadowRadius = 10.0f;
        _controlPanelBackground.layer.shouldRasterize = YES;
        [self addSubview:_controlPanelBackground];
        
        self.studentSelector = [[UBStudentSelectorView alloc] initWithStudents:nil];
        
        _createBreach = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_createBreach setTitle:@"New Breach" forState:UIControlStateNormal];
        [_createBreach sizeToFit];
        [self addSubview:_createBreach];
        
        _changeDate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_changeDate setTitle:@"Change Date" forState:UIControlStateNormal];
        [_changeDate sizeToFit];
        [self addSubview:_changeDate];
        
        self.selectorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.selectorLabel.text = @"People in This Session";
        [self.selectorLabel sizeToFit];
        [self addSubview:self.selectorLabel];
        
        _codesOrStudents = [[UISegmentedControl alloc] initWithItems:@[@"Students", @"Codes"]];
        _codesOrStudents.selectedSegmentIndex = 0;
        _codesOrStudents.segmentedControlStyle = UISegmentedControlStyleBar;
        [self addSubview:_codesOrStudents];
        
        self.subjects = [UBSubject all];
        NSArray *subjectNames = [self.subjects valueForKey:@"name"];
        
        _subject = [[UISegmentedControl alloc] initWithItems:subjectNames];
        _subject.selectedSegmentIndex = -1;
        _subject.segmentedControlStyle = UISegmentedControlStyleBar;
        [self addSubview:_subject];
        
        _listBg = [[UBShadowView alloc] init];
        [self addSubview:_listBg];
        
        _shrunk = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    // segemnted control is to be added as a nav item
    // _codesOrStudents.frame = CGRectPosition(_codesOrStudents.frame, LEFT_WIDTH, 0);
    
    _listBg.frame = CGRectMake(LEFT_WIDTH, 0, RIGHT_WIDTH, self.frame.size.height);
    [self bringSubviewToFront:_listBg];
    
    if (_studentSelector) {
        _studentSelector.frame = CGRectMake(10.0f, self.frame.size.height - 54.0f, LEFT_WIDTH - 20.0f, 54.0f);
    }
    if (_listSelectView) {
        _listSelectView.frame = CGRectPosition(_listBg.frame, 0, 0);
    }
    
    self.selectorLabel.frame = CGRectPosition(self.selectorLabel.frame, 10.0f, _studentSelector.frame.origin.y - self.selectorLabel.frame.size.height - 5.0f);
    
    _createBreach.frame = CGRectPosition(_createBreach.frame, 10.0f, self.selectorLabel.frame.origin.y - 44.0f);
    _changeDate.frame = CGRectPosition(_changeDate.frame, _createBreach.frame.origin.x + _createBreach.frame.size.width +2.0f, _createBreach.frame.origin.y);
    
    if (_shrunk) {
        _breachesView.frame = CGRectMake(0, 0, LEFT_WIDTH - 1.0f, self.frame.size.height - 350.0f);
    } else {
        _breachesView.frame = CGRectMake(0, 0, LEFT_WIDTH - 1.0f, _createBreach.frame.origin.y - 10.0f);
    }
    
    _controlPanelBackground.frame = CGRectMake(0, _breachesView.frame.size.height, LEFT_WIDTH - 1.0f, self.frame.size.height - _breachesView.frame.size.height);
}

- (void)setListSelectView:(UIView *)listSelectView
{
    [_listSelectView removeFromSuperview];
    _listSelectView = listSelectView;
    [_listBg addSubview:_listSelectView];
    [self layoutSubviews];
}

- (void)setStudentSelector:(UBStudentSelectorView *)studentSelector
{
    _studentSelector = studentSelector;
    [_studentSelector removeFromSuperview];
    [self addSubview:_studentSelector];
}

- (void)shrinkForTyping
{
    [UIView animateWithDuration:0.2f animations:^{
        self.breachesView.frame = CGRectSize(self.breachesView.frame, self.breachesView.frame.size.width, self.frame.size.height - 350.0f);
    }];
    _shrunk = YES;
}

- (void)doneTyping
{
    [UIView animateWithDuration:0.2f animations:^{
        self.breachesView.frame = CGRectSize(self.breachesView.frame, self.breachesView.frame.size.width, _createBreach.frame.origin.y - 10.0f);
    }];
    _shrunk = NO;
}

- (UBSubject *)selectedSubject
{
    if (self.subject.selectedSegmentIndex > -1) {
        return self.subjects[self.subject.selectedSegmentIndex];
    } else {
        return nil;
    }
}

- (void)setSelectedSubject:(UBSubject *)selectedSubject
{
    NSInteger index = [self.subjects indexOfObject:selectedSubject];
    if (index > -1) {
        self.subject.selectedSegmentIndex = index;
    }
}

@end
