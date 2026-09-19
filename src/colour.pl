:- module(colour, [palette/2, complementary_colour/2]).

palette(danger, palette{dominant:red,support:charcoal,highlight:cyan,shadow:maroon}) :- !.
palette(climax, palette{dominant:orange,support:deep_blue,highlight:gold,shadow:violet}) :- !.
palette(resolution, palette{dominant:amber,support:navy,highlight:pearl,shadow:indigo}) :- !.
palette(_, palette{dominant:blue,support:orange,highlight:white,shadow:slate}).

complementary_colour(orange, blue).
complementary_colour(blue, orange).
complementary_colour(yellow, violet).
complementary_colour(violet, yellow).
complementary_colour(red, cyan).
complementary_colour(cyan, red).
complementary_colour(green, magenta).
complementary_colour(Colour, complement_of(Colour)).
