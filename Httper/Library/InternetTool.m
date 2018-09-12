//
//  InternetTool.m
//  Httper
//
//  Created by Meng Li on 29/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//


#import "InternetTool.h"
#import "route.h"

// for "AF_INET"
#import <sys/socket.h>
//for ifaddrs
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

//for currentWiFi information
#import <SystemConfiguration/CaptiveNetwork.h>

//for gateway
#import <stdio.h>
#import <ctype.h>
#import <sys/param.h>
#import  <sys/sysctl.h>

#if TARGET_IPHONE_SIMULATOR
#include "route_simulator.h"
#else

#include "route.h"  /*the very same from google-code*/

#endif

#define CTL_NET         4               /* network, see socket.h */

#if defined(BSD) || defined(__APPLE__)
#define ROUNDUP(a) \
((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))
#endif

#define Interface_WiFi                 @"en0"
#define Interface_Cellular             @"pdp_ip0"

@implementation InternetTool

/*1. get local router information
 - local ip, gateway, netmask, broadcast address, interface, etc.(IPV4 address)
 - when using cellular network, I'm only sure that the ip address is correct,
 and I can not confirm other informations
 */
+ (NSMutableDictionary *)getRouterInfo {
    NSMutableDictionary *routerInfo = [NSMutableDictionary dictionary];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;

    // get cueernt interface - 0 success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;

        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                /* internetwork: UDP, TCP, etc. */

                //just get cellular||wifi info
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:Interface_WiFi] ||
                        [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:Interface_Cellular]) {

                    NSMutableDictionary *addressInfo = [NSMutableDictionary dictionary];

                    //local address
                    NSString *localAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                    NSString *broadcastAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_dstaddr)->sin_addr)];
                    NSString *netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_netmask)->sin_addr)];
                    NSString *interface = [NSString stringWithUTF8String:temp_addr->ifa_name];
                    if (localAddress) {
                        [addressInfo setObject:localAddress forKey:@"local"];

                        //getway
                        in_addr_t i = inet_addr([localAddress cStringUsingEncoding:NSUTF8StringEncoding]);
                        in_addr_t *x = &i;
                        NSString *gatewayAddress = [InternetTool getDefaultGateway:x withLocalAddress:localAddress];
                        if (gatewayAddress) {
                            [addressInfo setObject:gatewayAddress forKey:@"gateway"];
                        }
                    }
                    if (broadcastAddress) {
                        [addressInfo setObject:broadcastAddress forKey:@"broadcast"];
                    }
                    if (netmask) {
                        [addressInfo setObject:netmask forKey:@"netmask"];
                    }
                    if (interface) {
                        [addressInfo setObject:interface forKey:@"interface"];
                    }

                    //save addressinfo into routerinfo
                    if ([addressInfo count] > 0) {
                        if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:Interface_WiFi]) {
                            [addressInfo setObject:kTypeInfoKeyWifi forKey:@"type"];
                            [routerInfo setObject:addressInfo forKey:kTypeInfoKeyWifi];
                        } else if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:Interface_Cellular]) {
                            [addressInfo setObject:kTypeInfoKeyCellular forKey:@"type"];
                            [routerInfo setObject:addressInfo forKey:kTypeInfoKeyCellular];
                        }
                    }
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }

    // Free memory
    freeifaddrs(interfaces);

    return routerInfo;
}

//2. get default gateway address -> 192.168.1.19 - 192.168.1.1
// here we assume the first part of gateway address is the same like local address;

+ (NSString *)getDefaultGateway:(in_addr_t *)addr withLocalAddress:(NSString *)localAddress {
    NSString *result = nil;

#if 0
    /* net.route.0.inet.dump.0.0 ? */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_DUMP, 0, 0/*tableid*/};
#endif
    /* net.route.0.inet.flags.gateway */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
            NET_RT_FLAGS, RTF_GATEWAY};
    size_t l;
    char *buf, *p;
    struct rt_msghdr *rt;
    struct sockaddr *sa;
    struct sockaddr *sa_tab[RTAX_MAX];
    int i;
    if (sysctl(mib, sizeof(mib) / sizeof(int), 0, &l, 0, 0) < 0) {
        return result;
    }
    if (l > 0) {
        buf = malloc(l);
        if (sysctl(mib, sizeof(mib) / sizeof(int), buf, &l, 0, 0) < 0) {
            return result;
        }
        for (p = buf; p < buf + l; p += rt->rtm_msglen) {
            rt = (struct rt_msghdr *) p;
            sa = (struct sockaddr *) (rt + 1);
            for (i = 0; i < RTAX_MAX; i++) {
                if (rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *) ((char *) sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }

            if (((rt->rtm_addrs & (RTA_DST | RTA_GATEWAY)) == (RTA_DST | RTA_GATEWAY))
                    && sa_tab[RTAX_DST]->sa_family == AF_INET
                    && sa_tab[RTAX_GATEWAY]->sa_family == AF_INET) {

                unsigned char octet[4] = {0, 0, 0, 0};
                for (int i = 0; i < 4; i++) {
                    octet[i] = (((struct sockaddr_in *) (sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr >> (i * 8)) & 0xFF;
                }

                if (((struct sockaddr_in *) sa_tab[RTAX_DST])->sin_addr.s_addr == 0) {
                    NSArray *componts = [localAddress componentsSeparatedByString:@"."];
                    NSString *hrefOfLocalAddress = [componts objectAtIndex:0];
                    //assume the fitst part of gateway address is same like local address
                    if (octet[0] == [hrefOfLocalAddress integerValue]) {
                        *addr = ((struct sockaddr_in *) (sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr;
                        result = [NSString stringWithFormat:@"%d.%d.%d.%d", octet[0], octet[1], octet[2], octet[3]];
                    }
                }
            }
        }
        free(buf);
    }
    return result;
}

+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;

    success = getifaddrs(&interfaces);
    //O is success.
    if (success == 0) {

        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                }
            }

            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

@end
