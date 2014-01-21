//
//  HTMLPurifier_URIScheme.m
//  HTMLPurifier
//
//  Created by Lukas Neumann on 19.01.14.
//  Copyright (c) 2014 Mynigma. All rights reserved.
//

/**
 * Validator for the components of a URI for a specific scheme
 */

#import "HTMLPurifier_URIScheme.h"
#import "HTMLPurifier_Config.h"
#import "HTMLPurifier_Context.h"
#import "HTMLPurifier_URI.h"

@implementation HTMLPurifier_URIScheme

/**
 * Scheme's default port (integer). If an explicit port number is
 * specified that coincides with the default port, it will be
 * elided.
 * @type int
 */
@synthesize default_port; // = null;

/**
 * Whether or not URIs of this scheme are locatable by a browser
 * http and ftp are accessible, while mailto and news are not.
 * @type bool
 */
@synthesize browsable; // = false;

/**
 * Whether or not data transmitted over this scheme is encrypted.
 * https is secure, http is not.
 * @type bool
 */
@synthesize secure; // = false;

/**
 * Whether or not the URI always uses <hier_part>, resolves edge cases
 * with making relative URIs absolute
 * @type bool
 */
@synthesize hierarchical; // = false;

/**
 * Whether or not the URI may omit a hostname when the scheme is
 * explicitly specified, ala file:///path/to/file. As of writing,
 * 'file' is the only scheme that browsers support his properly.
 * @type bool
 */
@synthesize may_omit_host; // = false;

/**
 * Validates the components of a URI for a specific scheme.
 * @param HTMLPurifier_URI $uri Reference to a HTMLPurifier_URI object
 * @param HTMLPurifier_Config $config
 * @param HTMLPurifier_Context $context
 * @return bool success or failure
 */
-(BOOL) doValidate:(HTMLPurifier_URI*)uri config:(HTMLPurifier_Config*)config context:(HTMLPurifier_Context*)context
{
    NSLog(@"WARNING: URISCHEME - ABSTRACT FUNCTION CALLED");
    return YES;
}

/**
 * Public interface for validating components of a URI.  Performs a
 * bunch of default actions. Don't overload this method.
 * @param HTMLPurifier_URI $uri Reference to a HTMLPurifier_URI object
 * @param HTMLPurifier_Config $config
 * @param HTMLPurifier_Context $context
 * @return bool success or failure
 */
-(BOOL) validate:(HTMLPurifier_URI*)uri config:(HTMLPurifier_Config*)config context:(HTMLPurifier_Context*)context
{
    if (default_port.intValue == [uri port].intValue)
    {
        [uri setPort:nil];
    }
    // kludge: browsers do funny things when the scheme but not the
    // authority is set
    if ((!may_omit_host.boolValue &&
        // if the scheme is present, a missing host is always in error
        ([uri scheme] && (([uri host] == nil) || [[uri host] isEqual:@""]))) ||
        // if the scheme is not present, a *blank* host is in error,
        // since this translates into '///path' which most browsers
        // interpret as being 'http://path'.
        (![uri scheme] && [[uri host] isEqual:@""]))
    {
        do
        {
            if (![uri scheme])
            {
                if (![[[uri path] substringToIndex:2] isEqual:@"//"])
                {
                    [uri setHost:nil];
                    break;
                }
                // URI is '////path', so we cannot nullify the
                // host to preserve semantics.  Try expanding the
                // hostname instead (fall through)
            }
            // first see if we can manually insert a hostname
            NSString* host = (NSString*)[config get:@"URI.Host"];
            if (host)
            {
                [uri setHost:host];
            }
            else
            {
                // we can't do anything sensible, reject the URL.
                return NO;
            }
        } while (NO);
    }
    return [self doValidate:uri config:config context:context];
}

@end
