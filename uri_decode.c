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
#include <stddef.h>

#define __ 0xFF
static const unsigned char hexval[256] = {
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* 00-0F */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* 10-1F */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* 20-2F */
     0,  1,  2,  3,  4,  5,  6,  7,  8,  9, __, __, __, __, __, __, /* 30-3F */
    __, 10, 11, 12, 13, 14, 15, __, __, __, __, __, __, __, __, __, /* 40-4F */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* 50-5F */
    __, 10, 11, 12, 13, 14, 15, __, __, __, __, __, __, __, __, __, /* 60-6F */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* 70-7F */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* 80-8F */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* 90-9F */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* A0-AF */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* B0-BF */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* C0-CF */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* D0-DF */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* E0-EF */
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, /* F0-FF */
};

#undef __;

size_t
uri_decode(const char *s, size_t len, char *d) {
    const char *e;
    char *p = d;

    e = s + len - 2;
    for (; s < e; s++, d++) {
        if (*s != '%')
            *d = *s;
        else {
            const unsigned char v1 = hexval[(unsigned char)*++s];
            const unsigned char v2 = hexval[(unsigned char)*++s];
            if ((v1 | v2) != 0xFF)
                *d = (v1 << 4) | v2;
            else
                s -= 2, *d = *s;
        }
    }

    e += 2;
    for (; s < e; s++, d++)
        *d = *s;

    return d - p;
}

size_t
uri_decode_nocheck(const char *s, size_t len, char *d) {
    const char *e;
    char *p = d;

    e = s + len - 2;
    for (; s < e; s++, d++) {
        if (*s != '%')
            *d = *s;
        else {
            const unsigned char v1 = hexval[(unsigned char)*++s];
            const unsigned char v2 = hexval[(unsigned char)*++s];
            *d = (v1 << 4) | v2;
        }
    }

    e += 2;
    for (; s < e; s++, d++)
        *d = *s;

    return d - p;
}

