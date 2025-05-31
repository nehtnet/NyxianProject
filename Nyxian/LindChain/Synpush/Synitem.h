//
//  Synitem.h
//  Nyxian
//
//  Created by fridakitten on 17.04.25.
//

#ifndef SYNITEM_H
#define SYNITEM_H

#import <Foundation/Foundation.h>

@interface Synitem : NSObject

@property (nonatomic,readwrite) UInt64 line;
@property (nonatomic,readwrite) UInt64 column;
@property (nonatomic,readwrite) UInt8 type;
@property (nonatomic,strong) NSString *message;

+ (NSArray<Synitem*> *)OfClangErrorWithString:(NSString*)errorString;
+ (void)OfClangErrorWithString:(NSString*)errorString usingArray:(NSMutableArray<Synitem*> **)issues;

@end

#endif /* SYNITEM_H */
