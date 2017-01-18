//
//  StoreFavoritesViewController.m
//  Coupit
//
//  Created by geniemac5 on 12/12/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "StoreFavoritesViewController.h"
#import "jsonparse.h"
#import "appcommon.h"
#import "StoreListViewController.h"

@interface StoreFavoritesViewController ()
{
    NSString *userkey;
    NSMutableDictionary *favoritedic;
    NSMutableArray *favstoreNameArray,*favoritelist,*favstoreaddress,*favstoreThumbnail,*favstorenumber,*favstorelatarray,*favstorelongarray;
}

@end

@implementation StoreFavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - GREST Methods

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key {
    
    favoritedic = [[NSMutableDictionary alloc]init];
    
    favoritelist = [[response JSONValue] objectForKey:@"data"];
    
    favstoreNameArray = [[NSMutableArray alloc] init];
    favstoreaddress = [[NSMutableArray alloc] init];
    favstoreThumbnail = [[NSMutableArray alloc] init];
    favstorenumber = [[NSMutableArray alloc] init];
    favstorelatarray = [[NSMutableArray alloc] init];
    favstorelongarray = [[NSMutableArray alloc] init];
    
    favstoreNameArray=[favoritelist valueForKey:@"storename"];
    favstoreaddress = [favoritelist valueForKey:@"address"];
    favstoreThumbnail = [favoritelist valueForKey:@"storethumbnail"];
    favstorenumber = [favoritelist valueForKey:@"storeid"];
    favstorelatarray = [favoritelist valueForKey:@"latitude"];
    favstorelongarray = [favoritelist valueForKey:@"longitude"];
    
    [favoritetable reloadData];
    
}

- (void)request_failed:(NSError *)error for_key:(NSString *)request_key {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Couwalla"
                          message:@"Our server is down; please try again later."
                          delegate:self cancelButtonTitle:@"Close"
                          otherButtonTitles:nil];
	[alert show];
    
}

#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Store Favorites";
    // Do any additional setup after loading the view from its nib.
    
    api = [[GREST alloc] init];
    [api setDelegate:self];
    
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButtonclicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    
    [api post:[NSURL URLWithString:[NSString stringWithFormat:@"%@/get_mystores.php", BASE_URL]] with_params:@{@"user_id": userkey} contentType:@"application/x-www-form-urlencoded" with_key:@"getMyStores"];
    [api start];
    
    favstoreNameArray = [[NSMutableArray alloc] initWithArray:@[]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backButtonclicked
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([favstoreNameArray isKindOfClass:[NSNull class]]) {
        return 0;
    }
    return [favstoreNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellidentifier = @"iphone";
   // ExplorecareerTable.backgroundColor = [UIColor colorWithRed:(238.0/255.0) green:(233.0/255.0) blue:(233.0/255.0) alpha:1];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
//    NSString *title;
//    if (isSearching && [filteredList count]) {
//        //If the user is searching, use the list in our filteredList array.
//        title = [filteredList objectAtIndex:indexPath.row];
//    } else {
//        title = [Explorcareerarray objectAtIndex:indexPath.row];
//    }
//    //cell.backgroundColor = [UIColor colorWithRed:(238.0/255.0) green:(233.0/255.0) blue:(233.0/255.0) alpha:1];
    cell.textLabel.text = [favstoreNameArray objectAtIndex:indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
    tStoreListViewController.titlestring = [favstoreNameArray objectAtIndex:indexPath.row];
    tStoreListViewController.addressstring = [favstoreaddress objectAtIndex:indexPath.row];
    tStoreListViewController.tempstring = [favstoreThumbnail objectAtIndex:indexPath.row];
    tStoreListViewController.storeID = [favstorenumber objectAtIndex:indexPath.row];
    tStoreListViewController.latstring = [favstorelatarray objectAtIndex:indexPath.row];
    tStoreListViewController.longstring = [favstorelongarray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:tStoreListViewController animated:YES];
    
}



@end
