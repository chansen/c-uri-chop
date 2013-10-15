/*
 * Copyright (c) 2013 Christian Hansen <chansen@cpan.org>
 * <https://github.com/chansen/c-uri-chop>
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
#ifndef __URI_CHOP_H__
#define __URI_CHOP_H__
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    const char * scheme;
    size_t       scheme_len;
    const char * authority;
    size_t       authority_len;
    const char * userinfo;
    size_t       userinfo_len;
    const char * host;
    size_t       host_len;
    const char * port;
    size_t       port_len;
    const char * path;
    size_t       path_len;
    const char * query;
    size_t       query_len;
    const char * fragment;
    size_t       fragment_len;
} uri_chopped_t;

int
uri_chop(const char *src, size_t len, uri_chopped_t *res);

#ifdef __cplusplus
}
#endif
#endif

