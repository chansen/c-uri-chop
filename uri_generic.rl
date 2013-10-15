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

%%{
    machine uri_generic;

    ALPHA           = [A-Za-z];
    DIGIT           = [0-9];
    ALNUM           = ALPHA | DIGIT;
    HEXDIG          = DIGIT | [A-Fa-f];

    pct_encoded     = "%" HEXDIG HEXDIG;

    gen_delims      = ":" | "/" | "?" | "#" | "[" | "]" | "@";

    sub_delims      = "!" | "$" | "&" | "'" | "(" | ")"
                    | "*" | "+" | "," | ";" | "=";

    reserved        = gen_delims | sub_delims;

    unreserved      = ALPHA | DIGIT | "-" | "." | "_" | "~";

    pchar           = unreserved | pct_encoded | sub_delims | ":" | "@";

    segment         = pchar*;
    segment_nz      = pchar+;
    segment_nz_nc   = ( unreserved | pct_encoded | sub_delims | "@" )+;

    path_abempty    = ( "/" segment )*;
    path_absolute   = "/" ( segment_nz ( "/" segment )* )?;
    path_noscheme   = segment_nz_nc ( "/" segment )*;
    path_rootless   = segment_nz ( "/" segment )*;
    path_empty      = "";

    reg_name        = ( unreserved | pct_encoded | sub_delims )*;

    dec_octet       =            DIGIT   # 0-9
                    |      [1-9] DIGIT   # 10-99
                    | "1"  DIGIT DIGIT   # 100-199
                    | "2"  [0-4] DIGIT   # 200-249
                    | "25"       [0-5]   # 250-255
                    ;

    IPv4address     = dec_octet ( "." dec_octet ){3};

    h16             = HEXDIG{1,4};
    ls32            = h16 ":" h16 | IPv4address;

    IPv6address     =                                ( h16 ":" ){6} ls32
                    |                           "::" ( h16 ":" ){5} ls32
                    | (                  h16 )? "::" ( h16 ":" ){4} ls32
                    | ( ( h16 ":" ){0,1} h16 )? "::" ( h16 ":" ){3} ls32
                    | ( ( h16 ":" ){0,2} h16 )? "::" ( h16 ":" ){2} ls32
                    | ( ( h16 ":" ){0,3} h16 )? "::"   h16 ":"      ls32
                    | ( ( h16 ":" ){0,4} h16 )? "::"                ls32
                    | ( ( h16 ":" ){0,5} h16 )? "::"                h16
                    | ( ( h16 ":" ){0,6} h16 )? "::"
                    ;

    IPvFuture       = [Vv] HEXDIG+ "." ( unreserved | sub_delims | ":" )+;

    IP_literal      = "[" ( IPv6address | IPvFuture ) "]";

    host            = IP_literal | IPv4address | reg_name;
    port            = DIGIT*;
    userinfo        = ( unreserved | pct_encoded | sub_delims | ":" )*;

    query           = ( pchar | "/" | "?" )*;
    fragment        = ( pchar | "/" | "?" )*;

    scheme          = ALPHA ( ALPHA | DIGIT | "+" | "-" | "." )*;
}%%

