//
//  EditProfileValueCell.m
//  Coupit
//
//  Created by Canopus 4 on 14/05/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "EditProfileValueCell.h"

@implementation EditProfileValueCell

@synthesize profileItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:15.0];
        
        self.detailTextLabel.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
    }
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.text         = @"";
    self.detailTextLabel.text   = @"";
}

@end
