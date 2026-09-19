:- module(spec_expander, [expand_spec/2]).

:- use_module(sentence_parser).
:- use_module(concepts).

expand_spec(Sentence, ExpandedSpec) :-
    parse_sentence(Sentence, Parsed),
    Tokens = Parsed.tokens,
    infer_subjects(Tokens, Subjects),
    infer_actions(Tokens, Actions),
    infer_location(Tokens, Location),
    infer_weather(Tokens, Weather),
    infer_mood(Tokens, Mood),
    infer_style(Tokens, Style),
    infer_time(Tokens, Time),
    ExpandedSpec = spec{
        sentence:Sentence,
        subjects:Subjects,
        objects:[environment],
        actions:Actions,
        location:Location,
        time:Time,
        weather:Weather,
        mood:Mood,
        style:Style,
        colour_relationships:[subject_background_complement],
        camera_behaviour:[establishing_shot,push_in,tracking,reveal,wide_resolution],
        scene_progression:[establishing,action,closeup,climax,resolution],
        dramatic_events:[entrance,acceleration,reveal,surprise,visual_resolution],
        ending:toward_horizon,
        duration:20,
        aspect_ratio:'16:9'
    }.
