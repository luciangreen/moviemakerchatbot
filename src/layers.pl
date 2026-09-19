:- module(layers, [layer/2, default_layers/1]).

layer(1, sky).
layer(2, distant_background).
layer(3, background).
layer(4, middle_distance).
layer(5, subject).
layer(6, foreground).
layer(7, effects).
layer(8, lighting).
layer(9, interface).

default_layers(Layers) :-
    findall(layer(D, Name), layer(D, Name), Layers).
