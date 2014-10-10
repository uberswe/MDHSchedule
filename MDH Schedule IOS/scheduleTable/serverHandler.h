//
//  dataHandler.h
//  scheduleTable
//
//  Created by Ice on 2011-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerHandlerDelegate <NSObject>

@optional

- (void) serverHandlerHasLoadedScheduleData:(NSArray *)scheduleData;
- (void) serverHandlerReturnedError:(NSError *) error;

@end



@interface ServerHandler : NSObject{
    
@private
    NSURLConnection *connection;
    NSMutableData *inData;
    NSMutableArray *outData;
}

@property (assign, nonatomic) id delegate;

- (void) fetchEntries:(NSURL *)url;


@end



