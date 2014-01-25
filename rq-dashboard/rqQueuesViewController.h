//
//  rqQueuesViewController.h
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rqQueuesViewController : UITableViewController

@property (strong, nonatomic) NSArray *_queues;
@property (strong, nonatomic) NSTimer *timer;
@property float time;
@property float reload_timeout;
@property BOOL *is_loading;
@property (strong, atomic) IBOutlet UIProgressView *progress_view;
@property (strong, atomic) IBOutlet UIBarButtonItem *reload_button;

- (IBAction)refresh:(id)sender;

@end
