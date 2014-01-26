//
//  CommentsDisplayVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/24/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "CommentsDisplayVC.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "Comment.h"
#import "TTTTimeIntervalFormatter.h"

@interface CommentsDisplayVC ()

@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation CommentsDisplayVC

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[URLS baseURL]];
    }
    return _manager;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refresh];
}

- (void)refresh
{
    NSString *commentsURL = [NSString stringWithFormat:@"comments/%@",self.fight.fightID.description];
    commentsURL = [URLS appendSessionToken:commentsURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:commentsURL relativeToURL:self.manager.baseURL]];
                              
    [self.manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = (NSArray *)[responseObject objectForKey:@"comments"];
        
        NSMutableArray *comments = [[NSMutableArray alloc] init];
        for (NSDictionary *commentsDictionary in array) {
            Comment *c = [[Comment alloc]initWithDictionary:commentsDictionary];
            [comments addObject:c];
        }
        self.comments = [self sortCommentsArray:comments];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSArray *)sortCommentsArray:(NSArray *)array
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    // must override
    return mutableArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // amount of comments
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Comment Cell";
    
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:CellIdentifier];
    
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CommentCell *)currentObject;
                break;
            }
        }
    }
    
    Comment *comment = self.comments[indexPath.row];
    
    [cell.jabButton setImage:[self jabButtonImageForComment:comment] forState:UIControlStateNormal];
    cell.twitterHandleLabel.text = comment.author.handle;
    cell.commentContentLabel.text = comment.content;
    
    TTTTimeIntervalFormatter *formatter = [[TTTTimeIntervalFormatter alloc] init];
    
    // formatted time interval from comment date to now
    cell.commentDateTimeLabel.text = [formatter stringForTimeIntervalFromDate:comment.date toDate:[NSDate date]];
    cell.totalJabsLabel.text = [NSString stringWithFormat:@"%d",(int)comment.jabs];
    
    cell.delegate = self;
        
    return cell;
}

- (UIImage *)jabButtonImageForComment:(Comment *)comment
{
    if (comment.isJabbedByLoggedInUser) {
        return [UIImage imageNamed:@"jabbed"];
    } else {
        return [UIImage imageNamed:@"notjabbed"];
    }
}

-(void)jabComment:(Comment *)comment
{
    // send post
}

@end
