:- module(html_writer, [movie_assets/3, escape_html_text/2]).

movie_assets(HTML, css("body{margin:0}"), js("console.log('movie loaded')")) :- string(HTML).

escape_html_text(Value, Escaped) :-
    ( string(Value) -> Text = Value
    ; atom(Value) -> atom_string(Value, Text)
    ; term_string(Value, Text)
    ),
    string_codes(Text, Codes),
    escape_html_codes(Codes, EscapedCodes),
    string_codes(Escaped, EscapedCodes).

escape_html_codes([], []).
escape_html_codes([38|Codes], [38,97,109,112,59|Escaped]) :-
    !,
    escape_html_codes(Codes, Escaped).
escape_html_codes([60|Codes], [38,108,116,59|Escaped]) :-
    !,
    escape_html_codes(Codes, Escaped).
escape_html_codes([62|Codes], [38,103,116,59|Escaped]) :-
    !,
    escape_html_codes(Codes, Escaped).
escape_html_codes([34|Codes], [38,113,117,111,116,59|Escaped]) :-
    !,
    escape_html_codes(Codes, Escaped).
escape_html_codes([39|Codes], [38,35,51,57,59|Escaped]) :-
    !,
    escape_html_codes(Codes, Escaped).
escape_html_codes([Code|Codes], [Code|Escaped]) :-
    escape_html_codes(Codes, Escaped).
