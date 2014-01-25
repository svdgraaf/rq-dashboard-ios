//
//  RQQueueViewController.m
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import "RQQueueViewController.h"
#import <RestKit/RestKit.h>
#import "RQJobCell.h"
#import "RQJob.h"
#import "RQJobViewController.h"
#import "SORelativeDateTransformer.h"


@interface RQQueueViewController () {
    NSArray *_jobs;
    rqQueue *_queue;
    NSArray *_name;
}
@end

@implementation RQQueueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchJobs];
}

- (void)fetchJobs {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"jobs/%@.json", self._name] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray* jobs = [mappingResult array];
        NSLog(@"Loaded jobs: %@", jobs);
        self._jobs = jobs;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //        #todo add popup
    }];

}

- (IBAction)empty:(id)sender {
    [self._queue empty];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._jobs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RQJobCell";
    RQJobCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    RQJob *job = [self._jobs objectAtIndex:indexPath.row];
    [cell.originLabel setText:[job origin]];
    [cell.descriptionText setText:[job description]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    2014-01-15T19:10:40.402074+00:00"
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"];
    NSDate *readableDate = [dateFormatter dateFromString:[job created_at]];
    NSString *relativeDate = [[SORelativeDateTransformer registeredTransformer] transformedValue:readableDate];
    [cell.createdLabel setText:relativeDate];
    return cell;
}

- (IBAction)refresh:(id)sender {
    [self fetchJobs];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RQJobViewController *jobViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    RQJob *job = [self._jobs objectAtIndex:indexPath.row];
    jobViewController.job = job;
    // Pass the selected object to the new view controller.
}



@end
