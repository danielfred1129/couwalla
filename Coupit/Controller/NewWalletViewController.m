//
//  NewWalletViewController.m
//  Coupit
//
//  Created by Raphael Caixeta on 1/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "NewWalletViewController.h"
#import "LocalyticsSession.h"
#import "TableWalletCell.h"
#import "UIColor+AppTheme.h"

//@interface TableWalletCell: UITableViewCell
//
//@property (weak, nonatomic) IBOutlet UIImageView *imageViewWallet;
//@property (weak, nonatomic) IBOutlet UILabel *labelCardName;
//@property (weak, nonatomic) IBOutlet UILabel *labelBarcode;
//
//@end
//
//@implementation TableWalletCell
//@synthesize imageViewWallet,labelBarcode,labelCardName;
//
//@end

@implementation NewWalletViewController
{
    UIView *mGestureView;
	UIButton *mMenuButton;
    IBOutlet UIView *welcomeView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[mGestureView setBackgroundColor:[UIColor colorWithWhite:(0/255.0) alpha:0.4]];
    
    mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
    [mMenuButton sizeToFit];
	[mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    // [[UIScreen mainScreen] bounds].size.height
	UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
	[mGestureView addGestureRecognizer:recognizer];
    
	UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
	[mGestureView addGestureRecognizer:panRecognizer];
    
    self.navigationItem.title = @"Wallet";
    
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCard:)];
    
    listofCards = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reload];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kWalletScreen];
}

- (void)reload
{
    NSString* userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];

    [ZeeSQLiteHelper initializeSQLiteDB];
    NSMutableArray *results = [ZeeSQLiteHelper readQueryFromDB:[NSString stringWithFormat:@"SELECT * FROM wallet_cards where user_id=%@;",userid]];
    if([results count] == 0)
    {
        self.navigationItem.rightBarButtonItem=nil;
        mainTable.hidden=YES;
        welcomeView.hidden=NO;
        [listofCards removeAllObjects];
    } else
    {
        UIButton *rbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rbackButton.frame = CGRectMake(0, 0, 50, 30);
        [rbackButton setImage:[UIImage imageNamed:@"button_add"] forState:UIControlStateNormal];
       // [rbackButton sizeToFit];
        [rbackButton addTarget:self action:@selector(addCard:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rBackBar = [[UIBarButtonItem alloc]initWithCustomView:rbackButton];
        self.navigationItem.rightBarButtonItem = rBackBar;
        
        mainTable.hidden=NO;
        welcomeView.hidden=YES;
        listofCards = results;
    }
    [ZeeSQLiteHelper closeDatabase];
    [mainTable reloadData];
    
}

#pragma mark - Custom Methods
- (IBAction)addCard:(id)sender
{
    CreateNewCardViewController *createCard = [[CreateNewCardViewController alloc] initWithNibName:@"CreateNewCardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:createCard animated:YES];
    
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100.0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [listofCards count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *cardDetails = [listofCards objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier;
	CellIdentifier = @"identifier";
    TableWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TableWalletCell" owner:self options:nil];
        cell =  (TableWalletCell *)[topLevelObjects objectAtIndex:0];
        
        
       // cell = [[TableWalletCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFrontFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, cardDetails[@"front_pic_id"]];
    
    [cell.cardNameWallet setText:cardDetails[@"card_name"]];
    [cell.barcodeWallet setText:[NSString stringWithFormat:@"%@ - %@", cardDetails[@"barcode"], cardDetails[@"barcode_type"]]];
    [cell.imageViewWallet setImage:[UIImage imageWithContentsOfFile:pngFrontFilePath]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [mainTable deselectRowAtIndexPath:indexPath animated:YES];
    
    WalletCardViewerViewController *cardViewer = [[WalletCardViewerViewController alloc] initWithNibName:@"WalletCardViewerViewController" bundle:[NSBundle mainBundle]];
    [cardViewer setCardDetails:[listofCards objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:cardViewer animated:YES];
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Couwalla"
                              message:@"Are you sure you want to delete this card from your wallet?"
                              delegate:self cancelButtonTitle:@"Close"
                              otherButtonTitles:@"Delete", nil];
        [alert setTag:indexPath.row];
        [alert show];
        
    }
    
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(![alertView cancelButtonIndex] == buttonIndex)
    {
        NSDictionary *recordDetails = [listofCards objectAtIndex:alertView.tag];
        [ZeeSQLiteHelper initializeSQLiteDB];
        [ZeeSQLiteHelper executeQuery:[NSString stringWithFormat:@"DELETE FROM wallet_cards WHERE id = '%@';", recordDetails[@"id"]]];
        [ZeeSQLiteHelper closeDatabase];
        [self reload];
        
    }
    
}

-(void)showGestureView
{
	if (![self.view.subviews containsObject:mGestureView])
    {
		[self.view addSubview:mGestureView];
	}
}

-(void)hideGestureView {
	if ([self.view.subviews containsObject:mGestureView]) {
		[mGestureView removeFromSuperview];
	}
}

-(void)menuButtonSelected {
	mMenuButton.selected = YES;
}

-(void)menuButtonUnselected {
	mMenuButton.selected = NO;
}

@end
