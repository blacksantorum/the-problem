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

-(void)setFightArray;

@end

@implementation ScheduleViewController

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

-(void)setFightArray
{
    Boxer *jPascal = [[Boxer alloc] initWithFirst:@"Jean" Last:@"Pascal" Country:@"Canada"];
    Boxer *lBute = [[Boxer alloc] initWithFirst:@"Lucian" Last:@"Bute" Country:@"Canada"];
    Fight *a = [[Fight alloc] initWithDictionary:@{@"date" : @"01/18/2014", @"weight": @"175", @"location" : @"Montreal",
                                                   @"boxers" : @[jPascal,lBute], @"rounds" :@12}];
    [self.fights addObject:a];
    
    Boxer *tOosthuizen = [[Boxer alloc] initWithFirst:@"Thomas" Last:@"Oosthuizen" Country:@"South Africa"];
    Boxer *eAlvarez = [[Boxer alloc] initWithFirst:@"Eleider" Last:@"Alvarez" Country:@"Colombia"];
    Fight *a1 = [[Fight alloc] initWithDictionary:@{@"date" : @"01/18/2014", @"weight": @"175", @"location" : @"Montreal",
                                                   @"boxers" : @[tOosthuizen,eAlvarez], @"rounds" :@12}];
    [self.fights addObject:a1];
    
    Boxer *mPerez = [[Boxer alloc] initWithFirst:@"Mike" Last:@"Perez" Country:@"Cuba"];
    Boxer *cTakam = [[Boxer alloc] initWithFirst:@"Carlos" Last:@"Takam" Country:@"France"];
    Fight *a2 = [[Fight alloc] initWithDictionary:@{@"date" : @"01/18/2014", @"weight": @"hvy", @"location" : @"Montreal",
                                                   @"boxers" : @[mPerez,cTakam], @"rounds" :@10}];
    [self.fights addObject:a2];
    
    Boxer *mGarcia = [[Boxer alloc] initWithFirst:@"Mike" Last:@"Garcia" Country:@"USA"];
    Boxer *jBurgos = [[Boxer alloc] initWithFirst:@"Juan Carlos" Last:@"Burgos" Country:@"Mexico"];
    Fight *b = [[Fight alloc] initWithDictionary:@{@"date" : @"01/25/2014", @"weight": @"130", @"location" : @"New York City",
                                                   @"boxers" : @[mGarcia,jBurgos], @"rounds" :@12}];
    [self.fights addObject:b];
    
    Boxer *bJennings = [[Boxer alloc] initWithFirst:@"Bryant" Last:@"Jennings" Country:@"USA"];
    Boxer *aSzpilka = [[Boxer alloc] initWithFirst:@"Artur" Last:@"Szpilka" Country:@"Poland"];
    Fight *b1 = [[Fight alloc] initWithDictionary:@{@"date" : @"01/25/2014", @"weight": @"hvy", @"location" : @"New York City",
                                                   @"boxers" : @[bJennings,aSzpilka], @"rounds" :@10}];
    [self.fights addObject:b1];
    
    Boxer *lPeterson = [[Boxer alloc] initWithFirst:@"Lamont" Last:@"Peterson" Country:@"USA"];
    Boxer *dJean = [[Boxer alloc] initWithFirst:@"Dierry" Last:@"Jean" Country:@"France"];
    Fight *b2 = [[Fight alloc] initWithDictionary:@{@"date" : @"01/25/2014", @"weight": @"140", @"location" : @"Washington, DC",
                                                    @"boxers" : @[lPeterson,dJean], @"rounds" :@12}];
    [self.fights addObject:b2];
    
    Boxer *jCharlo = [[Boxer alloc] initWithFirst:@"Jermell" Last:@"Charlo" Country:@"USA"];
    Boxer *gRosado = [[Boxer alloc] initWithFirst:@"Gabriel" Last:@"Rosado" Country:@"USA"];
    Fight *b3 = [[Fight alloc] initWithDictionary:@{@"date" : @"01/25/2014", @"weight": @"160", @"location" : @"Washington, DC",
                                                    @"boxers" : @[jCharlo,gRosado], @"rounds" :@10}];
    [self.fights addObject:b3];
    
    Boxer *gGolovkin = [[Boxer alloc] initWithFirst:@"Gennady" Last:@"Golovkin" Country:@"Kazahkstan"];
    Boxer *oAdama = [[Boxer alloc] initWithFirst:@"Osumanu" Last:@"Adama" Country:@"Ghana"];
    Fight *c = [[Fight alloc] initWithDictionary:@{@"date" : @"02/01/2014", @"weight": @"160", @"location" : @"Monte Carlo",
                                                   @"boxers" : @[gGolovkin,oAdama], @"rounds" :@12}];
    [self.fights addObject:c];
    
    Boxer *iMakabu = [[Boxer alloc] initWithFirst:@"Ilunga" Last:@"Makabu" Country:@"Congo"];
    Boxer *pKolodziej = [[Boxer alloc] initWithFirst:@"Pawel" Last:@"Kolodziej" Country:@"Poland"];
    Fight *c1 = [[Fight alloc] initWithDictionary:@{@"date" : @"02/01/2014", @"weight": @"200", @"location" : @"Monte Carlo",
                                                   @"boxers" : @[iMakabu,pKolodziej], @"rounds" :@12}];
    [self.fights addObject:c1];
    
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
    [self setFightArray];

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
