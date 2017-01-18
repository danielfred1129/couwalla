//
//  LoyalCardListViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 5/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "LoyalCardListViewController.h"

@interface LoyalCardListViewController ()

@end

@implementation LoyalCardListViewController
{
    NSMutableArray *mCardArray;
}

@synthesize mDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Select Card";
   // self.tableView.backgroundView = nil;
    
    mCardArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
    
    UIButton *tcancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tcancelButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tcancelButton sizeToFit];
    [tcancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tcategoryCancel = [[UIBarButtonItem alloc]initWithCustomView:tcancelButton];
    self.navigationItem.leftBarButtonItem = tcategoryCancel;

    if ([mCardArray count] == 0) {
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:@"Wallet Empty" message:@"No card is added. Please add reward cards from wallets." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cancelButton:(UIBarButtonItem *)pBarButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [mCardArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Card *tCard = [mCardArray objectAtIndex:indexPath.row];
    cell.textLabel.text = tCard.mCardName;
    //cell.detailTextLabel.text = tCard.mCardNumber;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Card *tCard = [mCardArray objectAtIndex:indexPath.row];
    [mDelegate loyalCardListViewController:self selectedCard:tCard];
    
}

@end
