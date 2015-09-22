//
//  FeedsTableViewController.m
//  PacteraProficiencyTest
//
//  Created by Developer on 20/09/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "FeedsTableViewController.h"
#import "FeedList.h"
#import "FeedTableCellsTableViewCell.h"

static NSString* const kURL= @"https://dl.dropboxusercontent.com/u/746330/facts.json";

@interface FeedsTableViewController ()
@property (nonatomic,strong) NSArray *feedArray;
@property (nonatomic,copy) NSString *errorMsg;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@end

@implementation FeedsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(loadFromFeedURL) forControlEvents:UIControlEventValueChanged];
    self.errorMsg = @"Loading ....";
    [self.tableView  addSubview:self.tableRefreshControl];

    [self loadFromFeedURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadFromFeedURL{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [[NSURL alloc ]initWithString:kURL];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            //success
            if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
            
            if ([self.tableRefreshControl isRefreshing]) {
                [self.tableRefreshControl endRefreshing];
            }
            NSError *error1;
            NSString *serverResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSString *jsonString = [serverResponse stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSData *formattedJSON = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *localDisctionary = [NSJSONSerialization JSONObjectWithData:formattedJSON options:0 error:&error1];
            
            FeedList *feedlist = [[FeedList alloc]initWithJSONData:localDisctionary];
            
            if (self.feedArray) {
                self.feedArray = nil;
            }
            self.feedArray = feedlist.feedArray;
            self.title = feedlist.mainTitle;
            [serverResponse release];
            [feedlist release];
            [self.tableView reloadData];
        }
        else{
            //Error
            if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
            
            if ([self.tableRefreshControl isRefreshing]) {
                [self.tableRefreshControl endRefreshing];
            }
            self.errorMsg = [error localizedDescription];
            //NSLog(@"%@",error.localizedDescription);
            self.feedArray = nil;
            [self.tableView reloadData];
        }
        
    }]resume];
    [url release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.feedArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.feedArray count] == 0) { //  Default case for error handling
        UITableViewCell *loadingCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoDataIdentifier"]autorelease];
        loadingCell.textLabel.text = self.errorMsg;
        loadingCell.textLabel.font = [UIFont systemFontOfSize:14];
        loadingCell.textLabel.textAlignment = NSTextAlignmentCenter;
        return loadingCell;
    }

    
    Feed *feed = self.feedArray[indexPath.row];
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"CellIdentifier%ld", (long)[indexPath row]];
    
    FeedTableCellsTableViewCell *feedCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (feedCell == nil)
    {
        feedCell = [[[FeedTableCellsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier feed:feed]autorelease];
        [feedCell configureCell:feed];
    }
    return feedCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.feedArray count] == 0) { //  Default case for error handling
        return 50;
    }
    NSString *cellIdentifier = [NSString stringWithFormat:@"CellIdentifier%ld", (long)[indexPath row]];
    Feed *feed = self.feedArray[indexPath.row];
    
    FeedTableCellsTableViewCell * feedCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (feedCell == nil)
    {
        feedCell = [[[FeedTableCellsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier feed:feed]autorelease];
        [feedCell configureCell:feed];
    }
    int height = feedCell.contentView.frame.size.height;
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.feedArray count] == 0) {
        return;
    }
    Feed *feed = self.feedArray[indexPath.row];
    if (feed.feedImage == nil && feed.feedImageURL.length > 0) {
        FeedTableCellsTableViewCell *feedCell = (FeedTableCellsTableViewCell *)cell;

        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [[NSURL alloc ]initWithString:feed.feedImageURL];
        [[session dataTaskWithURL:url completionHandler:^(NSData *imageData, NSURLResponse *response, NSError *error) {
            if (!error) {
                //success
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    feedCell.feedImage.image = [UIImage imageWithData:imageData];
                    feed.feedImage = [UIImage imageWithData:imageData];
                });
            }
            else{
                //Error
                self.errorMsg = [error localizedDescription];
                //NSLog(@"%@",[self.errorMsg localizedDescription]);
                feedCell.feedImageWidthConstraint.constant = 0;
            }
            
        }]resume];
        [url release];
    }
}

-(void)dealloc{
    [_feedArray release];
    [_errorMsg release];
    [_tableRefreshControl release];
    [super dealloc];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
