//
//  RQQueueViewController.h
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RQQueueViewController : UITableViewController
@property (strong, nonatomic) NSString *_name;
@property (strong, nonatomic) NSArray *_jobs;

- (IBAction)refresh:(id)sender;

@end
