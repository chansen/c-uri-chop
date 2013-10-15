/*
 * Copyright (c) 2013 Christian Hansen <chansen@cpan.org>
 * <https://github.com/chansen/c-uri-split>
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer. 
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution. 
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#include <stddef.h>
#include "uri_chop.h"

#define SET_COMPONENT(c) do {   \
    res->c = mark;              \
    res->c##_len = p - mark;    \
} while (0)

%%{
    machine uri_chop;

    action mark {
        mark = fpc;
    }

    action scheme {
        SET_COMPONENT(scheme);
    }

    action userinfo {
        SET_COMPONENT(userinfo);
    }

    action host {
        SET_COMPONENT(host);
    }

    action port {
        SET_COMPONENT(port);
    }

    action path {
        SET_COMPONENT(path);
    }

    action query {
        SET_COMPONENT(query);
    }

    action fragment {
        SET_COMPONENT(fragment);
    }

    include uri_generic "uri_generic.rl";

    authority       = ( userinfo >mark %userinfo "@" )? host >mark %host ( ":" port >mark %port )?;

    relative_part   = "//" authority path_abempty >mark %path
                    | path_absolute >mark %path
                    | path_noscheme >mark %path
                    | path_empty >mark %path
                    ;

    relative_ref    = relative_part ( "?" query    >mark %query    )? 
                                    ( "#" fragment >mark %fragment )?;

    hier_part       = "//" authority path_abempty >mark %path
                    | path_absolute >mark %path
                    | path_rootless >mark %path
                    | path_empty >mark %path
                    ;

    URI             = scheme >mark %scheme ":" 
                      hier_part ( "?" query    >mark %query    )?
                                ( "#" fragment >mark %fragment )?;

    URI_reference   = URI | relative_ref;

    main           := URI_reference;

    write data;
}%%

static const uri_chopped_t empty = {
    NULL,   /* scheme        */
    0,      /* scheme_len    */
    NULL,   /* authority     */
    0,      /* authority_len */
    NULL,   /* userinfo      */
    0,      /* userinfo_len  */
    NULL,   /* host          */
    0,      /* host_len      */
    NULL,   /* port          */
    0,      /* port_len      */
    NULL,   /* path          */
    0,      /* path_len      */
    NULL,   /* query         */
    0,      /* query_len     */
    NULL,   /* fragment      */
    0,      /* fragment_len  */
};

int
uri_chop(const char *p, size_t len, uri_chopped_t *res) {
    const char *pe = p + len;
    const char *eof = pe;
    const char *mark = NULL;
    int cs;

    *res = empty;

    %% write init;
    %% write exec;

    if (cs < uri_chop_first_final)
        return -1;

    if (res->host) {
        if (res->userinfo)
            res->authority = res->userinfo;
        else
            res->authority = res->host;

        res->authority_len = res->path - res->authority;
    }
    return 0;
}

