//
//  BKSLoginViewController.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/26/14.
//
//

#import <UIKit/UIKit.h>
#import "BKSFlowStepDelegate.h"

@interface BKSLoginViewController : UIViewController
@property (nonatomic, weak) id<BKSFlowStepDelegate> delegate;

@end
