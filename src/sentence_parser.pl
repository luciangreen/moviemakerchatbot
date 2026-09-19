:- module(sentence_parser, [parse_sentence/2]).

parse_sentence(Sentence, Parsed) :-
    string_lower(Sentence, Lower),
    split_string(Lower, " ", ",.!?;:\n\t", Tokens0),
    exclude(==(""), Tokens0, Tokens),
    Parsed = parsed{tokens:Tokens, original:Sentence}.
