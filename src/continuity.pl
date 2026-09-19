:- module(continuity, [apply_continuity/2, scene_state/2]).

:- dynamic scene_state/2.

apply_continuity(Scenes, Scenes) :-
    retractall(scene_state(_,_)),
    forall(member(scene(I,_,_,_,Elements), Scenes),
           assertz(scene_state(I, state{elements:Elements}))).
