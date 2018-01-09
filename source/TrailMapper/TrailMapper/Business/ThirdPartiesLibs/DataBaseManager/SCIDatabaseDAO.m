
#import "SCIDatabaseDAO.h"
#import "FMDBUtils.h"

NSInteger const CONST_SELECT_QUERY = 5001;
NSInteger const CONST_INSERT_QUERY = 5002;
NSInteger const CONST_UPDATE_QUERY = 5003;
NSInteger const CONST_DELETE_QUERY = 5004;

static inline NSString* DefaultStringValue(NSString* value){
	if(value == nil || [value length] < 1){
		value = @"";
	}
	return value;
}

static SCIDatabaseDAO *userProfileDAO;

@implementation SCIDatabaseDAO

@synthesize objFMDatabase;

+ (SCIDatabaseDAO *)sharedDAO
{
    
    if (!userProfileDAO) 
    {
        userProfileDAO = [[SCIDatabaseDAO alloc] init];
    }

    return userProfileDAO;
}

- (void) initalizeDatabaseWithDBName:(NSString *)dbName
{
	
	FMDBUtils *objFMDBUtils= [[FMDBUtils alloc] initWithDatabase:dbName];
    objFMDatabase = [objFMDBUtils sharedDB];

}

- (id) executeQuery:(NSString*)query Type:(NSString*)type 
{
   
    NSLog(@"Query %@", query);
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
	BOOL isSuccess;
    switch ([self getQueryType:type]) {
        case 5001:
            arrResult = [self executeSelectQuery:query];
			return arrResult;
            break;

        case 5002:
			 isSuccess = [self executeInsertQuery:query];
           
            break;
 
		case 5003:
			 isSuccess = [self executeUpdateQuery:query];
           break;
            
        case 5004:
			isSuccess = [self executeDeleteQuery:query];
			break;
			
        default:
            break;
    }
    
    return nil;

}

- (NSInteger) getQueryType:(NSString*)type
{
    if([type isEqualToString:@"SELECT"]){
        return CONST_SELECT_QUERY;
    }else if([type isEqualToString:@"INSERT"]){
        return CONST_INSERT_QUERY;
    }else if([type isEqualToString:@"UPDATE"]){
        return CONST_UPDATE_QUERY;
    }else if([type isEqualToString:@"DELETE"]){
        return CONST_DELETE_QUERY;
    }return 1;
}

-(NSMutableArray*) executeSelectQuery:(NSString*)query
{
	FMResultSet *resultSet = [objFMDatabase executeQuery:query];
	
	NSMutableArray *results = [[NSMutableArray alloc] init];
	NSMutableArray *arrColumnNames = [[NSMutableArray alloc] init];
   
    int totalColumns = [resultSet columnCount];
    
    for (int i = 0; i < totalColumns; i++) {
        [arrColumnNames addObject:[resultSet columnNameForIndex:i]];
    }

    while ([resultSet next]) {
        NSMutableDictionary *dictRecords = [[NSMutableDictionary alloc] init];
        for (int i =0; i < totalColumns; i++) {
            NSString *coloumnValue = DefaultStringValue([resultSet stringForColumn:[arrColumnNames objectAtIndex:i]]) ;
            if (coloumnValue.length != 0 && ![coloumnValue isEqualToString:@"(null)"] && ![coloumnValue isEqualToString:@"nil"]) {
                [dictRecords setObject:coloumnValue forKey:[arrColumnNames objectAtIndex:i]];
            }
        }
        [results addObject:dictRecords];
        [dictRecords release];
        
    }
	[arrColumnNames release];
    //NSLog(@"Column Name : %@", results);
    return [results autorelease];
}

- (NSMutableArray*) getAllRowsForColumn:(NSString*)columnName withResultSet:(FMResultSet*)resultSet {
    NSMutableArray *arrResults = [[NSMutableArray alloc] init];
    while([resultSet next]){
        [arrResults addObject:[resultSet stringForColumn:columnName]];
    }
    return [arrResults autorelease];
}

- (BOOL) executeInsertQuery:(NSString*)query{
    BOOL success = NO;
    
    @try {
        [objFMDatabase executeUpdate:query];
        success = YES;
    }
    @catch (NSException *exception) {
        success = NO;
        NSLog(@"%@",[exception description]);
    }
	return success;
}

- (BOOL) executeUpdateQuery:(NSString*)query{
	return [objFMDatabase executeUpdate:query];
}

- (BOOL) executeDeleteQuery:(NSString*)query{
	return [objFMDatabase executeUpdate:query];

}

- (void)dealloc
{
    if(objFMDatabase){
		objFMDatabase = nil;
		[objFMDatabase release];
		
	}
    [super dealloc];
}

@end
