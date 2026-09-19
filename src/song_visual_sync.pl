:- module(song_visual_sync, [map_lyrics_to_visuals/2]).

map_lyrics_to_visuals(Analysis, Mappings) :-
    analysis{lyrical_points:Points} :< Analysis,
    findall(lyric_visual(Start, End, Point, visual_event(Point)),
            (nth1(I, Points, Point), Start is (I-1)*4, End is I*4),
            Mappings).
