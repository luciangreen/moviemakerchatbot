:- module(concepts,
    [ infer_subjects/2,
      infer_actions/2,
      infer_location/2,
      infer_weather/2,
      infer_mood/2,
      infer_style/2,
      infer_time/2
    ]).

infer_subjects(Tokens, Subjects) :-
    include(is_subject_token, Tokens, Raw),
    ( Raw = [] -> Subjects = [figure] ; list_to_set(Raw, Subjects) ).

infer_actions(Tokens, Actions) :-
    include(is_action_token, Tokens, Raw),
    ( Raw = [] -> Actions = [move] ; list_to_set(Raw, Actions) ).

infer_location(Tokens, Location) :-
    ( member(Token, Tokens), location_token(Token, Location) -> true ; Location = unknown_location ).

infer_weather(Tokens, Weather) :-
    ( member(Token, Tokens), weather_token(Token, Weather) -> true ; Weather = clear ).

infer_mood(Tokens, Mood) :-
    ( member(Token, Tokens), mood_token(Token, Mood) -> true ; Mood = cinematic ).

infer_style(Tokens, Style) :-
    ( member("pixel", Tokens) -> Style = pixel
    ; member("vector", Tokens) -> Style = vector
    ; member("rendered", Tokens) -> Style = rendered
    ; Style = pixel
    ).

infer_time(Tokens, Time) :-
    ( member(Token, Tokens), time_token(Token, Time) -> true ; Time = unspecified_time ).

is_subject_token(Token) :-
    \+ is_action_token(Token),
    \+ location_token(Token, _),
    \+ weather_token(Token, _),
    \+ mood_token(Token, _),
    \+ time_token(Token, _),
    atom_string(Atom, Token),
    \+ sub_atom(Atom, 0, 1, _, 'a'),
    \+ sub_atom(Atom, 0, 2, _, 'an'),
    \+ sub_atom(Atom, 0, 3, _, 'the').

is_action_token(Token) :- member(Token, ["runs","run","flies","fly","crosses","cross","escapes","escape","launches","launch","dances","dance","approaches","approach","jumps","jump"]).
location_token("city", city).
location_token("ocean", ocean).
location_token("palace", palace).
location_token("mountains", mountains).
location_token("moon", moon).
location_token("space", space).
location_token("melbourne", melbourne).

weather_token("storm", storm).
weather_token("thunderstorm", thunderstorm).
weather_token("rain", rain).
weather_token("snowy", snow).
weather_token("sunset", sunset).

mood_token("dramatic", dramatic).
mood_token("peaceful", peaceful).
mood_token("lonely", lonely).
mood_token("celebratory", celebratory).

time_token("sunset", sunset).
time_token("night", night).
time_token("dawn", dawn).
