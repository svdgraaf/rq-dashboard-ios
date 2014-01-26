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
#import "RQClient.h"
#import "RQDefaultCell.h"
#import "InAppSettings.h"
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
}

//    I don't think this should be here
- (void)viewWillAppear:(BOOL)animated {
    [RQClient reset];

    //    Check if we already have a url in the settings. if so, continue normally. If not
    //    popup the settings window
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *server_url = [defaults objectForKey:@"server_url"];
    NSLog(@"server_url: %@", server_url);
    if([server_url isEqualToString:@"http://example.com:9181/"]) {
        InAppSettingsModalViewController *settings = [[InAppSettingsModalViewController alloc] init];
        [self presentViewController:settings animated:NO completion:nil];
    }
    
    [self checkTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
}

- (void) checkTimer {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL auto_reload_queues = [defaults boolForKey:@"auto_reload_queues"];
    NSLog(@"auto_reload_queues: %d", auto_reload_queues);

    if(self.timer) {
        [self.timer invalidate];
        self.progress_view.progress = 0;
    }

    if(auto_reload_queues == YES) {
        self.time = 0;
        self.reload_timeout = [defaults floatForKey:@"auto_refresh_timeout"];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
        [self fetchQueues];
    }
}

- (void)fetchQueues {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:@"queues.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray* queues = [mappingResult array];
        NSLog(@"Loaded queues: %@", queues);
        self._queues = queues;
        [self countJobs];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        self.is_loading = NO;
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        #todo add popup
        NSLog(@"failure?");
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
//    rqDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if([queue.name isEqualToString:@"failed"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"rqFailedCell"];
        [cell.nameLabel setTextColor:[UIColor redColor]];
    }
    
    int x = ([queue.count intValue] * 310 / self.max_job_count);
    NSLog(@"width: %d", x);
    CGRect frame = CGRectMake(0,0, x, 44);
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
