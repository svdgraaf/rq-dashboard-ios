//
//  rqDefaultCell.h
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rqDefaultCell : UITableViewCell

@property (strong, nonatomic) UILabel IBOutlet *nameLabel;
@property (strong, nonatomic) UILabel IBOutlet *countLabel;

@end
