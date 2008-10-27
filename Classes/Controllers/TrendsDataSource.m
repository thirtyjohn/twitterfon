//
//  TrendsDataSource.m
//  TwitterFon
//
//  Created by kaz on 10/26/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import "TrendsDataSource.h"
#import "TwitterClient.h"

@interface NSObject (TrendsDataSourceDelegate)
- (void)searchTrendsDidLoad;
- (void)searchTrendsDidFailToLoad;
- (void)search:(NSString*)query;
@end

@implementation TrendsDataSource

- (id)initWithDelegate:(id)aDelegate
{
    [super init];
    trends = [[NSMutableArray alloc] init];
    delegate = aDelegate;
    return self;
}

- (void)dealloc
{ 
    [trends release];
    [super dealloc];
}


- (void)getTrends
{
    TwitterClient *client = [TwitterClient alloc];
    [client initWithDelegate:self];
    [client trends];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [trends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.text = [trends objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [delegate search:[trends objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];  
}

//
// TwitterClient delegates
//
- (void)twitterClientDidSucceed:(TwitterClient*)sender messages:(NSObject*)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary*)obj;
        
        NSArray *array = (NSArray*)[dic objectForKey:@"trends"];
        
        [trends removeAllObjects];
        for (int i = 0; i < [array count]; ++i) {
            NSDictionary *trend = (NSDictionary*)[array objectAtIndex:i];
            [trends addObject:(NSString*)[trend objectForKey:@"name"]];
        }            
    }
    [delegate searchTrendsDidLoad];
    [sender autorelease];
}

- (void)twitterClientDidFail:(TwitterClient*)sender error:(NSString*)error detail:(NSString*)detail
{
    [delegate searchTrendsDidFailToLoad];
}


@end