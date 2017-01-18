//
//  EditProfileListCell.m
//  Coupit
//
//  Created by Canopus 4 on 14/05/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "EditProfileListCell.h"

@implementation EditProfileListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:15.0];

        self.detailTextLabel.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
        
        self.inputField = [[IQDropDownTextField alloc]initWithFrame:CGRectMake(150, 0, self.frame.size.width-20, self.frame.size.height)];
        self.inputField.borderStyle = UITextBorderStyleNone;
        self.inputField.textAlignment = NSTextAlignmentRight;
        self.inputField.placeholder =@"Select";
        self.accessoryView = self.inputField;
    }
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
    self.inputField.selectedItem = nil;
    
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
