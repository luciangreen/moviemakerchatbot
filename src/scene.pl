:- module(scene, [make_scene/6]).

make_scene(Index, Start, End, Kind, Spec, scene(Index,Start,End,Kind,Elements)) :-
    Spec.subjects = [Primary|_],
    Elements = [
        background(Spec.location),
        lighting(Spec.time),
        weather(Spec.weather),
        object(Primary, position(50,60), size(1.0), appearance(silhouette), motion(Kind)),
        transition(cut),
        caption(Spec.sentence)
    ].
