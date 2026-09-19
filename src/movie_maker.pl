:- module(movie_maker,
    [ movie/3,
      movie_html/2,
      movie_vector/2,
      movie_rendered/2,
      movie_and_song/3,
      regenerate/4
    ]).

:- use_module(spec_expander).
:- use_module(dramatisation).
:- use_module(story).
:- use_module(storyboard).
:- use_module(continuity).
:- use_module(colour).
:- use_module(camera).
:- use_module(dynamic_stills).
:- use_module(visual_rhythm).
:- use_module(song_adapter).
:- use_module(pixel_renderer).
:- use_module(vector_renderer).
:- use_module(rendered_renderer).

movie(SentenceSpec, Options, Movie) :-
    expand_spec(SentenceSpec, Expanded0),
    merge_options(Options, Expanded0, Expanded),
    dramatise(Expanded, Dramatised),
    build_story(Dramatised, Story),
    spec_to_scenes(Dramatised, Story, Scenes0),
    apply_scene_adornments(Scenes0, Scenes1),
    apply_continuity(Scenes1, Scenes),
    option(duration(Duration), Options, 20),
    option(style(Style), Options, pixel),
    Movie = movie([
        title(SentenceSpec),
        duration(Duration),
        style(Style),
        seed_from_options(Options),
        scenes(Scenes)
    ]).

movie_html(SentenceSpec, HTML) :-
    movie(SentenceSpec, [style(pixel)], Movie),
    render_pixel_movie(Movie, HTML).

movie_vector(SentenceSpec, HTML) :-
    movie(SentenceSpec, [style(vector)], Movie),
    render_vector_movie(Movie, HTML).

movie_rendered(SentenceSpec, HTML) :-
    movie(SentenceSpec, [style(rendered)], Movie),
    render_rendered_movie(Movie, HTML).

movie_and_song(SentenceSpec, Movie, Song) :-
    movie(SentenceSpec, [style(rendered)], Movie),
    movie_to_song_spec(Movie, SongSpec),
    song_spec_to_song(SongSpec, Song).

regenerate(Target, Instruction, Movie0, Movie1) :-
    Movie0 = movie(Parts0),
    select(scenes(Scenes0), Parts0, PartsNoScenes),
    regenerate_scenes(Target, Instruction, Scenes0, Scenes1),
    Movie1 = movie([scenes(Scenes1)|PartsNoScenes]).

merge_options([], Spec, Spec).
merge_options([duration(Duration)|Rest], Spec0, Spec) :-
    put_dict(duration, Spec0, Duration, Spec1),
    merge_options(Rest, Spec1, Spec).
merge_options([style(Style)|Rest], Spec0, Spec) :-
    put_dict(style, Spec0, Style, Spec1),
    merge_options(Rest, Spec1, Spec).
merge_options([aspect_ratio(Ratio)|Rest], Spec0, Spec) :-
    put_dict(aspect_ratio, Spec0, Ratio, Spec1),
    merge_options(Rest, Spec1, Spec).
merge_options([seed(Seed)|Rest], Spec0, Spec) :-
    put_dict(seed, Spec0, Seed, Spec1),
    merge_options(Rest, Spec1, Spec).
merge_options([_|Rest], Spec0, Spec) :-
    merge_options(Rest, Spec0, Spec).

seed_from_options(Options) :-
    option(seed(Seed), Options),
    !,
    Seed.
seed_from_options(_) :- random_between(1, 99999, Seed), Seed.

apply_scene_adornments([], []).
apply_scene_adornments([scene(I,S,E,T,Elements0)|Rest], [scene(I,S,E,T,Elements)|OutRest]) :-
    palette(T, Palette),
    camera_for_scene(T, S-E, Camera),
    dynamic_still_for_scene(T, DynamicStill),
    visual_beats(S-E, Beats),
    append(Elements0,
           [palette(Palette), camera(Camera), dynamic_still(DynamicStill), visual_beats(Beats)],
           Elements),
    apply_scene_adornments(Rest, OutRest).

regenerate_scenes(scene(Index), Instruction, Scenes0, Scenes1) :-
    !,
    maplist(regenerate_scene(Index, Instruction), Scenes0, Scenes1).
regenerate_scenes(_, Instruction, Scenes0, Scenes1) :-
    maplist(add_instruction(Instruction), Scenes0, Scenes1).

regenerate_scene(Index, Instruction, scene(Index,S,E,T,Elements0), scene(Index,S,E,T,Elements1)) :-
    !,
    append(Elements0, [edit_instruction(Instruction)], Elements1).
regenerate_scene(_, _, Scene, Scene).

add_instruction(Instruction, scene(I,S,E,T,Elements0), scene(I,S,E,T,Elements1)) :-
    append(Elements0, [edit_instruction(Instruction)], Elements1).
