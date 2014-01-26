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
    int total_jobs;
    int max_job_count;
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

    self.time = 0;
    self.reload_timeout = 2;
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
        [self countJobs];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        #todo add popup
    }];
}

- (void)countJobs {
    self.total_jobs = 0;
    self.max_job_count = 0;
    for (rqQueue *queue in self._queues) {
        self.total_jobs += [queue.count intValue];
        if([queue.count intValue] > self.max_job_count) {
            self.max_job_count = [queue.count intValue];
        }
    }
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
    
    int x = ([queue.count intValue] * 320 / self.max_job_count);
    CGRect frame = CGRectMake(0,0, x, 44);
//    CGRect *frame = [cell.backgroundView.frame copy];
//    NSLog(@"frame: %@", frame);
    [cell.progressView setFrame:frame];

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
