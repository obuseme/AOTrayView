//
//  MasterViewController.m
//  AOTrayViewDemo
//
//  Created by Andrew Obusek on 9/18/12.
//  Copyright (c) 2012 Andrew Obusek. All rights reserved.
//

#import "MasterViewController.h"
#import "AOTrayView.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableDictionary *_selectedItems;
    AOTrayView *_trayView;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)dealloc
{
    [_objects release];
    [_selectedItems release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _objects = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", nil];
    _selectedItems = [[NSMutableDictionary alloc] initWithCapacity:1];
    float overlayHeight = 15.0;
    float trayHeight = 55.0;
    _trayView = [[AOTrayView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+overlayHeight, self.view.frame.size.width, trayHeight + overlayHeight) andSingleItemLabel:@"1 item selected" andMultiItemLabel:@" items selected"];
    _trayView.overlayHeight = overlayHeight;
    _trayView.trayHeight = trayHeight;
    _trayView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_trayView];
    [_trayView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }


    NSDate *object = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIView *thumbnail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _trayView.trayHeight-10, _trayView.trayHeight-10)];
    thumbnail.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _trayView.trayHeight-10, _trayView.trayHeight-10)];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18.0];
    label.text = [[_objects objectAtIndex:indexPath.row] description];
    label.backgroundColor = [UIColor clearColor];
    [thumbnail addSubview:label];
    [label release];
    
    if ([_selectedItems objectForKey:[[_objects objectAtIndex:indexPath.row] description]]) {

        [_selectedItems removeObjectForKey:[[_objects objectAtIndex:indexPath.row] description]];
        [_trayView remove:[NSDictionary dictionaryWithObjectsAndKeys:thumbnail, @"view", [[_objects objectAtIndex:indexPath.row] description], @
                               "id", nil] adjacentViewToResize:tableView];

    } else {
        [_trayView add:[NSDictionary dictionaryWithObjectsAndKeys:thumbnail, @"view", [[_objects objectAtIndex:indexPath.row] description], @
                        "id", nil] adjacentViewToResize:tableView];
        [thumbnail release];
        [_selectedItems setObject:[_objects objectAtIndex:indexPath.row] forKey:[[_objects objectAtIndex:indexPath.row] description]];
    }
}

@end
