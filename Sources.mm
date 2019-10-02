/* Phalena - iPhone UIKit Front-End for Debian APT
 * Copyright (C) 2008-2013  Jay Freeman (saurik)
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

#include <Foundation/Foundation.h>
#include <Menes/ObjectHandle.h>

#include <cstdio>

#include "Sources.h"

NSString *Cache_;

NSString *Cache(const char *file) {
    return [NSString stringWithFormat:@"%@/%s", Cache_, file];
}

extern _H<NSMutableDictionary> Sources_;

void PhalenaWriteSources() {
    auto sources([SOURCES_LIST UTF8String]);
    unlink(sources);
    FILE *file(fopen(sources, "w"));
    _assert(file != NULL);

    fprintf(file, "deb http://apt.saurik.com/ ios/%.2f main\n", kCFCoreFoundationVersionNumber);

    for (NSString *key in [Sources_ allKeys]) {
        if ([key hasPrefix:@"deb:http:"] && [Sources_ objectForKey:[NSString stringWithFormat:@"deb:https:%s", [key UTF8String] + 9]])
            continue;

        NSDictionary *source([Sources_ objectForKey:key]);

        NSArray *sections([source objectForKey:@"Sections"] ?: [NSArray array]);

        fprintf(file, "%s %s %s%s%s\n",
            [[source objectForKey:@"Type"] UTF8String],
            [[source objectForKey:@"URI"] UTF8String],
            [[source objectForKey:@"Distribution"] UTF8String],
            [sections count] == 0 ? "" : " ",
            [[sections componentsJoinedByString:@" "] UTF8String]
        );
    }

    fclose(file);
}

void PhalenaAddSource(NSDictionary *source) {
    [Sources_ setObject:source forKey:[NSString stringWithFormat:@"%@:%@:%@", [source objectForKey:@"Type"], [source objectForKey:@"URI"], [source objectForKey:@"Distribution"]]];
}

void PhalenaAddSource(NSString *href, NSString *distribution, NSArray *sections) {
    if (href == nil || distribution == nil)
        return;

    PhalenaAddSource([NSMutableDictionary dictionaryWithObjectsAndKeys:
        @"deb", @"Type",
        href, @"URI",
        distribution, @"Distribution",
        sections ?: [NSMutableArray array], @"Sections",
    nil]);
}
