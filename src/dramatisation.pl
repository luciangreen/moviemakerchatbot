:- module(dramatisation, [dramatise/2]).

dramatise(Spec, DramatisedSpec) :-
    Beats = [anticipation,entrance,acceleration,interruption,climax,resolution],
    put_dict(_{dramatisation:Beats,
               creative_surprise:foreground_crossing_reveal,
               emotional_progression:[setup,tension,release]}, Spec, DramatisedSpec).
