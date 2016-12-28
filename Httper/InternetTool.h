//
//  InternetTool.h
//  Httper
//
//  Created by 李大爷的电脑 on 29/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTypeInfoKeyWifi               @"wifi"
#define kTypeInfoKeyCellular           @"cellular"

@interface InternetTool : NSObject

/* get local router information
 - local ip, gateway, netmask, broadcast address, interface, etc.(IPV4 address)
 - when using cellular network, I'm only sure that the ip address is correct,
 and I can not confirm other informations
 */
+(NSMutableDictionary *)getRouterInfo;

// Get device ip.
+ (NSString *)deviceIPAdress;

@end
