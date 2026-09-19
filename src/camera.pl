:- module(camera, [camera_for_scene/3]).

camera_for_scene(establishing, Start-End, camera(extreme_wide, position(0,0,100), target(center), 1.0, slow_push, Duration)) :-
    Duration is End-Start, !.
camera_for_scene(action, Start-End, camera(wide, position(0,10,70), target(subject), 1.2, tracking, Duration)) :-
    Duration is End-Start, !.
camera_for_scene(closeup, Start-End, camera(closeup, position(0,5,30), target(subject), 1.8, orbit, Duration)) :-
    Duration is End-Start, !.
camera_for_scene(climax, Start-End, camera(low_angle, position(0,-5,45), target(subject), 2.0, push_in, Duration)) :-
    Duration is End-Start, !.
camera_for_scene(_, Start-End, camera(wide, position(0,0,80), target(subject), 1.0, pull_back, Duration)) :-
    Duration is End-Start.
