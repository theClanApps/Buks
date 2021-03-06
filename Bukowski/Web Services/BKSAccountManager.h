//
//  BKSAccountManager.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/26/14.
//
//

#import <Foundation/Foundation.h>

typedef void (^BKSSuccessBlock) (id successObject);
typedef void (^BKSErrorBlock) (NSError *error);

@interface BKSAccountManager : NSObject
+ (id)sharedAccountManager;

- (void)logout;

- (void)loginWithWithSuccess:(BKSSuccessBlock)success failure:(BKSErrorBlock)failure;

@end
