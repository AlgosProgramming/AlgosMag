 
//
//  Articolo.h
//  vttt
//
//  Created by Marco Velluto on 09/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Articolo : NSObject
{
    NSString *code;
    NSString *name;
    NSString *category;
    NSString *description;
    float *price;
}

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) float *price;

@end
