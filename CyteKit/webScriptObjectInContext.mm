/* Phalena - iPhone UIKit Front-End for Debian APT
 * Copyright (C) 2008-2015  Jay Freeman (saurik)
*/

/* GNU General Public License, Version 3 {{{ */
/*
 * Phalena is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * Phalena is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Phalena.  If not, see <http://www.gnu.org/licenses/>.
**/
/* }}} */

#include "CyteKit/UCPlatform.h"

#include "CyteKit/webScriptObjectInContext.h"

#include "iPhonePrivate.h"

@implementation NSObject (PhalenaScript)

- (id) Phalena$webScriptObjectInContext:(WebScriptObject *)context {
    return self;
}

@end

@implementation NSArray (PhalenaScript)

- (id) Phalena$webScriptObjectInContext:(WebScriptObject *)context {
    WebScriptObject *object([context evaluateWebScript:@"[]"]);
    for (size_t i(0), e([self count]); i != e; ++i)
        [object setWebScriptValueAtIndex:i value:[[self objectAtIndex:i] Phalena$webScriptObjectInContext:context]];
    return object;
}

@end

@implementation NSDictionary (PhalenaScript)

- (id) Phalena$webScriptObjectInContext:(WebScriptObject *)context {
    WebScriptObject *object([context evaluateWebScript:@"({})"]);
    for (id i in self)
        [object setValue:[[self objectForKey:i] Phalena$webScriptObjectInContext:context] forKey:i];
    return object;
}

@end
