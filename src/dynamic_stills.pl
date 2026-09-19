:- module(dynamic_stills, [dynamic_still_for_scene/2]).

dynamic_still_for_scene(establishing, dynamic_still([water,clouds,camera_drift])).
dynamic_still_for_scene(closeup, dynamic_still([fabric,eyes,smoke])).
dynamic_still_for_scene(resolution, dynamic_still([sunlight,reflections])).
dynamic_still_for_scene(_, action_emphasis).
