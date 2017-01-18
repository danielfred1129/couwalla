//
//  EditProfileCell.m
//  Coupit
//
//  Created by  on 10/2/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "EditProfileCell.h"

@implementation EditProfileCell

@synthesize inputField,profileItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:15.0];

        self.detailTextLabel.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];

        self.inputField = [[UITextField alloc]initWithFrame:CGRectMake(130, 0, self.frame.size.width/2, self.frame.size.height)];
        self.inputField.borderStyle = UITextBorderStyleNone;
        self.inputField.textAlignment = NSTextAlignmentRight;
        self.accessoryView = self.inputField;
    }
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
    self.inputField.text = @"";
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
