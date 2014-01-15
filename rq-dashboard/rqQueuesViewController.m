//
//  rqQueuesViewController.m
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import "rqQueuesViewController.h"
#import <RestKit/RestKit.h>
#import "rqQueue.h"
#import "RQDefaultCell.h"
#import "RQQueueViewController.h"


@interface rqQueuesViewController () {
    NSArray *_queues;
}
@end

@implementation rqQueuesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self fetchQueues];
}

- (void)fetchQueues {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:@"queues.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray* queues = [mappingResult array];
        NSLog(@"Loaded queues: %@", queues);
        self._queues = queues;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        #todo add popup
    }];
}

- (IBAction)refresh:(id)sender {
    [self fetchQueues];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._queues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"rqDefaultCell";
    rqDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    rqQueue *queue = [self._queues objectAtIndex:indexPath.row];
    [cell.nameLabel setText:queue.name];
    if([queue.name isEqualToString:@"failed"]) {
        [cell.nameLabel setTextColor:[UIColor redColor]];
    }
    [cell.countLabel setText:queue.count];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showQueue"]) {
//        SerinusTabBarViewController *destViewController = (SerinusTabBarViewController*);
        
//        if(sender == self.searchDisplayController.searchResultsTableView) {
//            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
//            SerinusCompany *company = self._searchResults[indexPath.row];
//            [destViewController.navigationItem setTitle:[company name]];
//            [[segue destinationViewController] setDetailItem:company];
//        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            rqQueue *queue = [self._queues objectAtIndex:indexPath.row];
//            SerinusCompany *company;
//            if([self hasFavorites] && indexPath.section == 0) {
//                company = self._favorites[indexPath.row];
//            } else {
//                company = self._companies[indexPath.row];
//            }
            RQQueueViewController *dvc = [segue destinationViewController];
            [dvc.navigationItem setTitle:[queue name]];
            dvc._name = [queue name];
        
//            [[segue destinationViewController] setDetailItem:company];
//        }
    }
}

@end
