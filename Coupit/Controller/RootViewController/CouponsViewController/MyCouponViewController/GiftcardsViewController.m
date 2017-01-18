//
//  GiftcardsViewController.m
//  Coupit
//
//  Created by geniemac5 on 11/01/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "GiftcardsViewController.h"
#import "MyCouponsCell.h"

@interface GiftcardsViewController ()

@end

@implementation GiftcardsViewController
@synthesize gTableview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) notificationDictionary:(NSDictionary *)pDict
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
    //
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCouponsCell *cell;

    //
    //    if ((tableView.tag=1)) {
    //        static NSString *CellIdentifier = @"MyCouponsCell";
    //        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //        if (cell == nil) {
    //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //
    //        }
    //        cell.textLabel.text = [menuarray objectAtIndex:indexPath.row];
    //        return cell;
    //
    //    }pu
    
    static NSString *CellIdentifier = @"MyCouponsCell";
    cell = (MyCouponsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyCouponsCell" owner:self options:nil];
        cell = (MyCouponsCell *)[topLevelObjects objectAtIndex:0];
    }
    [cell.mSeperatorImageView setHidden:YES];
    [cell.mCouponCodeLabel setHidden:YES];
    
    return cell;
}

@end
