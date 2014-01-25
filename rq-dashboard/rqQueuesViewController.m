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
    NSTimer *timer;
    float time;
    float reload_timeout;
    BOOL is_loading;
    UIProgressView *progress_view;
    UIRefreshControl *refresh_control;
    UIBarButtonItem *reload_button;
}
@end

@implementation rqQueuesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.time = 0;
    self.reload_timeout = 10;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
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
            self.is_loading = NO;
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        #todo add popup
    }];
}

- (IBAction)refresh:(id)sender {
    if(sender == self.reload_button || sender == self.refresh_control) {
        // refresh was pushed, force reload
        NSLog(@"update forced");
        [self fetchQueues];
        self.time = self.reload_timeout; // force update
    }
    
    if(self.time >= self.reload_timeout) {
        self.time = 0;
        self.progress_view.progress = 0;
        [self fetchQueues];
        
    } else {
        self.time += 0.1f;
        self.progress_view.progress = self.time / self.reload_timeout;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._queues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    rqQueue *queue = [self._queues objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"rqDefaultCell";
    rqDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if([queue.name isEqualToString:@"failed"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"rqFailedCell"];
        [cell.nameLabel setTextColor:[UIColor redColor]];
    }

    [cell.nameLabel setText:queue.name];
    [cell.countLabel setText:queue.count];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showQueue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        rqQueue *queue = [self._queues objectAtIndex:indexPath.row];

        RQQueueViewController *dvc = [segue destinationViewController];
        dvc._queue = queue;
        [dvc.navigationItem setTitle:[queue name]];
        dvc._name = [queue name];
    }
}

@end
