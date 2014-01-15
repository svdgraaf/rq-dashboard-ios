//
//  RQJobCell.h
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RQJobCell : UITableViewCell

@property (strong, nonatomic) UILabel IBOutlet *originLabel;
@property (strong, nonatomic) UILabel IBOutlet *createdLabel;
@property (strong, nonatomic) UITextView IBOutlet *descriptionText;

@end
