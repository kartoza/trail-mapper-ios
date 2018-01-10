
#import <Foundation/Foundation.h>
#include "FMDatabase.h"

@interface SCIDatabaseDAO : NSObject{
    FMDatabase *objFMDatabase;
}
//Property
@property(nonatomic, retain) FMDatabase *objFMDatabase;

// Class Methods
+ (SCIDatabaseDAO *)sharedDAO;

// Public Methods
- (void) initalizeDatabaseWithDBName:(NSString *)dbName;
- (NSMutableArray*) executeQuery:(NSString*)query Type:(NSString*)type;
- (BOOL) executeInsertQuery:(NSString*)query;
- (BOOL) executeUpdateQuery:(NSString*)query;
- (BOOL) executeDeleteQuery:(NSString*)query;
@end
