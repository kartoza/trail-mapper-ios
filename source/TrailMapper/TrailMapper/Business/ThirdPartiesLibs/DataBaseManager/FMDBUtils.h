//
//  FMDBUtils.h
//  MyHeadline
//
//  Created by Ravi Deshmukh on 19/01/12.
//  Copyright 2012 afaf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface FMDBUtils : NSObject {
	FMDatabase * sharedDBObj;
	NSString *dbPath;
}

@property (nonatomic, retain) NSString * dbPath;

-(FMDatabase *) sharedDB;
-(FMDBUtils *) initWithDatabase:  (NSString *) dbFile;
-(void) startDatabase ;

@end