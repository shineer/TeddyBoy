//
//  ConsoleViewController.h
//  lezhuliEnterpriseEx
//
//  Created by born on 13-1-8.
//
//

#import <UIKit/UIKit.h>


@interface ConsoleViewController : UIViewController
+(UINavigationController*)shareSingleton;
-(void)appendMsg:(NSString*)msg;
@end
