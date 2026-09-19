:- module(action, [action_scene/3]).

action_scene(Action, Environment, Frames) :-
    action_stages(Action, BaseStages),
    maplist(wrap_frame(Environment), BaseStages, Frames).

action_stages(jump_between_buildings,
    [run,accelerate,plant_foot,launch,airborne_extension,descent,landing,impact_absorption,recovery]) :- !.
action_stages(escape,
    [stillness,look_around,breakaway,sprint,obstacle,leap,hide,reveal]) :- !.
action_stages(_, [anticipation,start,accelerate,peak,recover]).

wrap_frame(Environment, Stage, frame(Environment, Stage)).
