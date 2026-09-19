:- module(visual_rhythm, [visual_beats/2]).

visual_beats(Start-End, [
    visual_beat(Start, cut),
    visual_beat(Start+0.2, movement_start),
    visual_beat((Start+End)/2, reveal),
    visual_beat(End-0.2, colour_change),
    visual_beat(End, camera_change)
]).
