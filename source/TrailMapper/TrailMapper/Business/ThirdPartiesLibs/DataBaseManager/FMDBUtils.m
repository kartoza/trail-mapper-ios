//
//  FMDBUtils.m
//  MyHeadline
//
//  Created by Ravi Deshmukh on 19/01/12.
//  Copyright 2012 afaf. All rights reserved.
//

#import "FMDBUtils.h"

@implementation FMDBUtils

@synthesize dbPath;

-(FMDBUtils *) initWithDatabase:  (NSString *) dbFile {
	self = [super init];
	
	if(self) {
		self.dbPath = dbFile;
		[self startDatabase];
	}
	
	return self;
}

-(void)startDatabase{
	
	BOOL succeeded;
	NSError *error;
	
	//First check if the database is already present in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbPath];
	
	NSFileManager * fileManager = [NSFileManager defaultManager];
	succeeded = [fileManager fileExistsAtPath:writableDBPath]; 
    
	if(succeeded)
	{
		NSLog(@"File exist : %@",documentsDirectory);	
        
		FMDatabase *db = [FMDatabase databaseWithPath:writableDBPath];
		succeeded = [db open];
		if(succeeded)
		{
			sharedDBObj = [db retain];
		}
		else {
			sharedDBObj = nil;
		}	
	} else {
        
		NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbPath];
        
		succeeded = [fileManager copyItemAtPath:dbpath toPath:writableDBPath error:&error]; 
		NSLog(@"DBpath : %@ ",writableDBPath);
		if(succeeded == FALSE)
		{
			NSLog(@"Copy Database failed");
			
		}		
		
		FMDatabase *db = [FMDatabase databaseWithPath:writableDBPath];
		succeeded = [db open];
		if(succeeded)
		{
			sharedDBObj = [db retain];
		}
		else {
			sharedDBObj = nil;
		}		
	}
	NSLog(@"Started the Database");
}

- (void)dealloc {
	if(sharedDBObj) {
		[sharedDBObj close];
		[sharedDBObj release];
	}
	[dbPath release];
    [super dealloc];
}

-(FMDatabase *) sharedDB {	
	if(![sharedDBObj goodConnection]) {
		[self startDatabase];
	}
	
	return sharedDBObj;
}

@end
