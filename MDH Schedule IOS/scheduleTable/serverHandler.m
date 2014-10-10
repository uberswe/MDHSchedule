//
//  dataHandler.m
//  scheduleTable
//
//  Created by Ice on 2011-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServerHandler.h"


@implementation ServerHandler

@synthesize delegate;


- (id) init {
    
    self = [super init];
    return self;
}

-(void) fetchEntries:(NSURL *) url {
    
    NSLog(@"fetchEntries %@", url);
    inData = [[NSMutableData alloc] init];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [inData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *str = [[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding];
    outData = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\n"]];
    //NSLog(@"outData: = \n%@", outStr);
    
    NSString *okString = [NSString stringWithFormat:@"Schedule: %@", [outData objectAtIndex:0]];
    NSLog(@"%@", okString);
    
    SEL updateMethod = @selector(serverHandlerHasLoadedScheduleData:);
    
    if ([[self delegate] respondsToSelector:updateMethod]) {
        [[self delegate] serverHandlerHasLoadedScheduleData:outData];
    }
}

-(void) connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    connection = nil;
    
    inData = nil;
    
    SEL updateMethod = @selector(serverHandlerReturnedError:);
    
    if ([[self delegate] respondsToSelector:updateMethod]) {
        [[self delegate] serverHandlerReturnedError:error];
    }
    
}

@end

