:- module(song_adapter,
    [ movie_to_song_spec/2,
      song_to_movie_timing/2,
      song_spec_to_song/2
    ]).

movie_to_song_spec(movie(Parts), song_spec(Sections, Mood, Tempo)) :-
    member(title(Title), Parts),
    Sections = [intro,verse,pre_chorus,chorus,bridge,final_chorus,outro],
    Mood = based_on(Title),
    Tempo = 112.

song_spec_to_song(song_spec(Sections, Mood, Tempo), song{sections:Sections,mood:Mood,tempo:Tempo}).

song_to_movie_timing(Song, Timing) :-
    song{sections:Sections,tempo:Tempo} :< Song,
    length(Sections, Count),
    SectionDur is max(2, round(60 / max(1, Tempo/30))),
    findall(section_timing(S, Start, End),
            (nth1(I, Sections, S), Start is (I-1)*SectionDur, End is I*SectionDur),
            Timing),
    Count > 0.
