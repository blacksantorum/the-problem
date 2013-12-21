//
//  ScheduleViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 12/15/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Fight.h"
#import "Boxer.h"
#import "FightDetailViewController.h"

@interface ScheduleViewController ()

@property (nonatomic, strong) NSMutableArray *fights; //of Fights


-(NSArray *)arrayOfDates;

-(NSArray *)fightsForDate:(NSDate *)date;

-(NSString *)sectionHeaderFormattedDate:(NSDate *)date;

-(void)refresh;

@end

@implementation ScheduleViewController

-(void)refresh
{
    NSString *url = @"http://the-boxing-app.herokuapp.com/fights";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", connectionError);
        } else {
            NSError *error = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            //NSLog(@"%@", object);
            if (error) {
                NSLog(@"JSON parsing error: %@", error);
            } else {
                NSArray *array = (NSArray *)object;
                for (NSDictionary *fightParams in array) {
                    NSMutableArray *boxers = [[NSMutableArray alloc] init];
                    NSDictionary *boxersDict = [fightParams objectForKey:@"boxers"];
                    for (NSDictionary *boxerParams in boxersDict) {
                        Boxer *b = [[Boxer alloc ]initWithDictionary:boxerParams];
                        NSLog(@"%@",b);
                        [boxers addObject:b];
                    }
                    Fight *fight = [[Fight alloc] initWithDictionary:fightParams];
                    fight.boxers = boxers;
                    NSLog(@"%@",fight);
                    [self.fights addObject:fight];
                //[self.refreshControl endRefreshing];
                [self.tableView reloadData];
                }
            }
        }
    }];

}

-(NSArray *)arrayOfDates
{
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    for (Fight *f in self.fights) {
        [dateArray addObject:f.date];
    }
    NSSet *uniqueEvents = [NSSet setWithArray:dateArray];
    return [[uniqueEvents allObjects] sortedArrayUsingSelector:@selector(compare:)];
}

-(NSArray *)fightsForDate:(NSDate *)date
{
    NSMutableArray *fights = [[NSMutableArray alloc] init];
    for (Fight *f in self.fights) {
        if ([f.date isEqualToDate:date]) {
            [fights addObject:f];
        }
    }
    return fights;
}

-(NSString *)sectionHeaderFormattedDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    NSLog(@"%@", [dateFormatter stringFromDate:date]);
    
    NSString *partiallyFormattedDate = [dateFormatter stringFromDate:date];
    return [partiallyFormattedDate substringWithRange:NSMakeRange(0, [partiallyFormattedDate length] - 6)];
}



-(NSArray *)fights
{
    if(!_fights) {
        _fights = [[NSMutableArray alloc] init];
    }
    return _fights;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fightDetail"]) {
        FightDetailViewController *controller = (FightDetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        NSDate *date = [[self arrayOfDates] objectAtIndex:indexPath.section];
        NSArray *fightsForDate = [self fightsForDate:date];
        
        controller.fight = fightsForDate[indexPath.row];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self arrayOfDates].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSDate *date = [[self arrayOfDates] objectAtIndex:section];
    NSArray *fightsForDate = [self fightsForDate:date];
    return fightsForDate.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *date = [[self arrayOfDates] objectAtIndex:section];
    return [self sectionHeaderFormattedDate:date];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Fight Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDate *date = [[self arrayOfDates] objectAtIndex:indexPath.section];
    NSArray *fightArrayAtDate = [self fightsForDate:date];
    NSLog(@"%@",fightArrayAtDate);
    // set text to Aside-BSide
    Fight *fight = fightArrayAtDate[indexPath.row];
    cell.textLabel.text = fight.titleForScheduleView;
    cell.detailTextLabel.text = @"";
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
