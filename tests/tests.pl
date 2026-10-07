:- begin_tests(movie_maker).

:- use_module('../src/movie_maker').
:- use_module('../src/spec_expander').
:- use_module('../src/storyboard').
:- use_module('../src/continuity').
:- use_module('../src/colour').
:- use_module('../src/action').
:- use_module('../src/camera').
:- use_module('../src/pixel_renderer').
:- use_module('../src/vector_renderer').
:- use_module('../src/rendered_renderer').
:- use_module('../src/server').
:- use_module('../src/song_adapter').
:- use_module('../src/song_analysis').
:- use_module('../src/song_visual_sync').
:- use_module('../tests/io_pairs').

test(sentence_parsing_and_expansion) :-
    expand_spec("A plane flies through clouds.", Spec),
    _{subjects:Subjects,actions:Actions,scene_progression:Progression} :< Spec,
    Subjects \= [],
    Actions \= [],
    Progression \= [].

test(story_generation_and_scene_ordering) :-
    movie("A rocket launches.", [duration(20)], movie(Parts)),
    member(scenes(Scenes), Parts),
    Scenes = [scene(1,Start1,End1,_,_)|_],
    Start1 =:= 0,
    End1 > Start1.

test(continuity_state_created) :-
    movie("A cat runs through a futuristic city.", [], movie(Parts)),
    member(scenes(Scenes), Parts),
    apply_continuity(Scenes, _),
    scene_state(1, _).

test(complementary_colours) :-
    complementary_colour(orange, blue),
    complementary_colour(yellow, violet).

test(action_interpolation) :-
    action_scene(jump_between_buildings, rooftops, Frames),
    member(frame(rooftops, launch), Frames),
    member(frame(rooftops, landing), Frames).

test(camera_instructions) :-
    camera_for_scene(establishing, 0-3, camera(extreme_wide,_,_,_,_,3)).

test(pixel_rendering) :-
    movie_html("A ship crosses the ocean.", HTML),
    sub_string(HTML, _, _, _, "pixel-frame").

test(vector_rendering) :-
    movie_vector("Two astronauts dance on the moon.", HTML),
    sub_string(HTML, _, _, _, "<svg").

test(renderer_escapes_prompt_text) :-
    movie_vector("<script>alert(1)</script>", HTML),
    sub_string(HTML, _, _, _, "&lt;script&gt;alert(1)&lt;/script&gt;"),
    \+ sub_string(HTML, _, _, _, "<script>alert(1)</script>").

test(rendered_rendering) :-
    movie_rendered("A giant wave approaches a coastal city.", HTML),
    sub_string(HTML, _, _, _, "<canvas").

test(song_integration) :-
    movie_and_song("A lonely traveller finally comes home.", _Movie, Song),
    song_to_movie_timing(Song, Timing),
    Timing \= [].

test(lyric_visual_mapping) :-
    analyse_song(song{sections:[intro,verse,chorus]}, Analysis),
    map_lyrics_to_visuals(Analysis, Mappings),
    Mappings \= [].

test(regeneration) :-
    movie("A tiger escapes from a palace during a thunderstorm.", [], Movie0),
    regenerate(scene(4), "Make this more spectacular", Movie0, Movie1),
    Movie1 \= Movie0.

test(regeneration_target_parsing) :-
    server:parse_regeneration_target("scene(2)", scene(2)),
    server:parse_regeneration_target(3, scene(3)).

test(regeneration_target_rejects_invalid, [throws(error(domain_error(regeneration_target, _), _))]) :-
    server:parse_regeneration_target("scene(0)", _).

test(regeneration_rejects_missing_scene, [throws(error(domain_error(existing_scene, scene(6)), _))]) :-
    movie("A tiger escapes from a palace during a thunderstorm.", [], Movie),
    server:validate_regeneration_target(scene(6), Movie).

test(regeneration_updates_only_requested_scene) :-
    movie("A tiger escapes from a palace during a thunderstorm.", [], Movie0),
    regenerate(scene(2), "Add a close-up", Movie0, movie(Parts)),
    member(scenes(Scenes), Parts),
    member(scene(2, _, _, _, Elements), Scenes),
    member(edit_instruction("Add a close-up"), Elements),
    member(scene(1, _, _, _, OtherElements), Scenes),
    \+ member(edit_instruction(_), OtherElements).

test(io_pair_concept_coverage) :-
    forall(
        io_pair(_, Sentence, expected(Requirements)),
        ( member(subjects([Subject]), Requirements),
          atom_string(Subject, SubjectString),
          member(actions([Action]), Requirements),
          atom_string(Action, ActionString),
          member(location(Location), Requirements),
          member(weather(Weather), Requirements),
          expand_spec(Sentence, Spec),
          Spec.subjects == [SubjectString],
          Spec.actions == [ActionString],
          Spec.location == Location,
          Spec.weather == Weather
        )
    ).

test(export_modes) :-
    movie_html("A red train races through snowy mountains.", HTML1),
    movie_vector("A red train races through snowy mountains.", HTML2),
    movie_rendered("A red train races through snowy mountains.", HTML3),
    HTML1 \= HTML2,
    HTML2 \= HTML3.

test(io_pairs_count) :-
    findall(Id, io_pair(Id, _, _), Ids),
    length(Ids, N),
    N >= 200.

% Integration tests requested by requirements

test(integration_test_movie_pixel) :-
    movie("A red train races through snowy mountains.", [style(pixel)], movie(Parts)),
    member(style(pixel), Parts).

test(integration_test_movie_vector) :-
    movie("Two astronauts dance on the moon.", [style(vector)], movie(Parts)),
    member(style(vector), Parts).

test(integration_test_movie_rendered) :-
    movie("A giant wave approaches a coastal city.", [style(rendered)], movie(Parts)),
    member(style(rendered), Parts).

test(integration_test_movie_song) :-
    movie_and_song("A lonely traveller finally comes home.", Movie, Song),
    nonvar(Movie),
    nonvar(Song).

:- end_tests(movie_maker).
