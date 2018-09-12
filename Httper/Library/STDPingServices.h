//
//  STDPingServices.h
//  Httper
//
//  Created by Meng Li on 27/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SimplePing.h"

typedef NS_ENUM(NSInteger, STDPingStatus) {
    STDPingStatusDidStart,
    STDPingStatusDidFailToSendPacket,
    STDPingStatusDidReceivePacket,
    STDPingStatusDidReceiveUnexpectedPacket,
    STDPingStatusDidTimeout,
    STDPingStatusError,
    STDPingStatusFinished,
};

@interface STDPingItem : NSObject

@property(nonatomic) NSString *originalAddress;
@property(nonatomic, copy) NSString *IPAddress;

@property(nonatomic) NSUInteger dateBytesLength;
@property(nonatomic) double     timeMilliseconds;
@property(nonatomic) NSInteger  timeToLive;
@property(nonatomic) NSInteger  ICMPSequence;

@property(nonatomic) STDPingStatus status;

+ (NSString *)statisticsWithPingItems:(NSArray *)pingItems;

@end

@interface STDPingServices : NSObject

// Timeout, default is 500ms
@property(nonatomic) double timeoutMilliseconds;

+ (STDPingServices *)startPingAddress:(NSString *)address
                      callbackHandler:(void(^)(STDPingItem *pingItem, NSArray *pingItems))handler;

@property(nonatomic) NSInteger  maximumPingTimes;
- (void)cancel;

@end
