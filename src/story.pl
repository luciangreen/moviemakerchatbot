:- module(story, [build_story/2]).

build_story(Spec, Story) :-
    Story = story{
        title:Spec.sentence,
        acts:[setup,confrontation,climax,resolution],
        motif:[motif(freedom, open_sky), motif(danger, red_flash)],
        ending:Spec.ending
    }.
