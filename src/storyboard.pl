:- module(storyboard, [spec_to_scenes/3]).

:- use_module(scene).

spec_to_scenes(Spec, _Story, Scenes) :-
    Duration = Spec.duration,
    Phase is Duration / 5,
    make_scene(1, 0, Phase, establishing, Spec, S1),
    make_scene(2, Phase, Phase*2, action, Spec, S2),
    make_scene(3, Phase*2, Phase*3, closeup, Spec, S3),
    make_scene(4, Phase*3, Phase*4, climax, Spec, S4),
    make_scene(5, Phase*4, Duration, resolution, Spec, S5),
    Scenes = [S1,S2,S3,S4,S5].
