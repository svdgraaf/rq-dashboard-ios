//
//  RQJobViewController.m
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/25/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import "RQJobViewController.h"
#import "RQJob.h"
#import "RQJobDetailCell.h"

@interface RQJobViewController () {
    RQJob *job;
}
@end

@implementation RQJobViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (IBAction)cancel:(id)sender {
    [self.job cancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"detailLabel";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(indexPath.section == 4) {
        RQJobDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailText" forIndexPath:indexPath];
        [cell.descriptionText setText:self.job.description];
        cell.descriptionText.frame = CGRectMake(0,0,tableView.frame.size.width, cell.descriptionText.contentSize.height);

        return cell;
    }

    if(indexPath.section == 6) {
        RQJobDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailText" forIndexPath:indexPath];
        [cell.descriptionText setText:self.job.exc_info];
        cell.descriptionText.frame = CGRectMake(0,0,tableView.frame.size.width, cell.descriptionText.contentSize.height);
        
        return cell;
    }

    
    // Configure the cell...
//    [cell.textLabel setText:self.job.origin];
    switch(indexPath.section) {
        case 0:
            [cell.textLabel setText:self.job.origin];
            break;
        case 1:
            [cell.textLabel setText:self.job.ended_at];
            break;
        case 2:
            [cell.textLabel setText:self.job.created_at];
            break;
        case 3:
            [cell.textLabel setText:self.job.enqueued_at];
            break;
        case 5:
            [cell.textLabel setText:self.job.result];
            break;
        case 6:
            [cell.textLabel setText:self.job.exc_info];
            break;
        case 7:
            [cell.textLabel setText:self.job.identifier];
            break;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return @"origin";
        case 1:
            return @"ended_at";
        case 2:
            return @"created_at";
        case 3:
            return @"enqueued_at";
        case 4:
            return @"description";
        case 5:
            return @"result";
        case 6:
            return @"exc_info";
        case 7:
            return @"identifier";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 4 && indexPath.section != 6) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    CGSize textViewSize;
    UIFont *courier = [UIFont fontWithName:@"Menlo" size:12];
    if(indexPath.section == 4) {
        textViewSize = [self.job.description sizeWithFont:courier
                                        constrainedToSize:CGSizeMake(tableView.frame.size.width, FLT_MAX)
                                            lineBreakMode:NSLineBreakByWordWrapping];
    }
    if (indexPath.section == 6) {
        textViewSize = [self.job.exc_info sizeWithFont:courier
                                               constrainedToSize:CGSizeMake(tableView.frame.size.width, FLT_MAX)
                                                   lineBreakMode:NSLineBreakByWordWrapping];
    }
    NSLog(@"size: %f x %f", textViewSize.height, textViewSize.width);
    int targetSize = textViewSize.height + 20;
    if (targetSize > 50) {
        return targetSize;
    } else {
        return 70;
    }
}


@end
