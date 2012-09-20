//
//  AOTrayViewDemoTests.m
//  AOTrayViewDemoTests
//
//  Created by Andrew Obusek on 9/18/12.
//  Copyright (c) 2012 Andrew Obusek. All rights reserved.
//

#import "AOTrayViewTests.h"
#import "AOTrayView.h"
#import "OCMockObject.h"

@interface AOTrayViewTests () {
    OCMockObject *doneButton;
    AOTrayView *toTest;
}
@end

@implementation AOTrayViewTests

- (void)setUp
{
    [super setUp];
    
    toTest = [[AOTrayView alloc] init];
    doneButton = [OCMockObject mockForClass:[UIButton class]];
    
    [toTest setValue:doneButton forKey:@"doneButton"];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testConfigureDoneButton
{
    [[doneButton expect] setFrame:CGRectMake(220, 0, 100, toTest.trayHeight)];
    [[doneButton expect] setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [toTest performSelector:@selector(configureDoneButton:) withObject:nil];
}

@end
