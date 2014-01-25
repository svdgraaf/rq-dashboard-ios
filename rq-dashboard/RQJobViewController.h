//
//  RQJobViewController.h
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/25/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RQJob.h"

@interface RQJobViewController : UITableViewController
@property (strong, nonatomic) RQJob *job;

//- (void)setJob:(RQJob *)job;

@end
