:- module(song_analysis, [analyse_song/2]).

analyse_song(Song, analysis{structure:Sections,lyrical_points:[darkness,reveal,climax,resolution]}) :-
    song{sections:Sections} :< Song.
