//
//  HTMLPurifier_AttrDef_TextDecoration.h
//  HTMLPurifier
//
//  Created by Roman Priebe on 11.01.14.
//  Copyright (c) 2014 Mynigma. All rights reserved.
//

#import "HTMLPurifier_AttrDef.h"

@interface HTMLPurifier_AttrDef_TextDecoration : HTMLPurifier_AttrDef

    /**
     * @param string $string
     * @param HTMLPurifier_Config $config
     * @param HTMLPurifier_Context $context
     * @return bool|string
     */
- (NSString*)validateWithString:(NSString *)string config:(HTMLPurifier_Config *)config context:(HTMLPurifier_Context *)context;

@end
