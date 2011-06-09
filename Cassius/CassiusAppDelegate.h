//
//  CassiusAppDelegate.h
//  Cassius
//
//  Created by ktang on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CassiusViewController;

@interface CassiusAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CassiusViewController *viewController;

@end
