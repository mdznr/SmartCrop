//
//  NSRegularExpression+PerfectMatch.h
//  SmartCrop
//
//  Created by Matt Zanchelli on 4/22/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (PerfectMatch)

///	Returns whether or not the string is a perfect match of the regular expression (matching the full range of the string).
///	@param string The string to search.
///	@param options The matching options to use. See “NSMatchingOptions” for possible values.
///	@return Whether or not the full range of the string matches the receiving regular expression.
- (BOOL)perfectlyMatchesString:(NSString *)string options:(NSMatchingOptions)options;

@end
