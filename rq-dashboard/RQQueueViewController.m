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
#import "SORelativeDateTransformer.h"


@interface RQQueueViewController () {
    NSArray *_jobs;
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
