:- module(vector_renderer, [render_vector_movie/2]).

render_vector_movie(movie(Parts), HTML) :-
    member(title(Title), Parts),
    format(string(HTML), "<html><body style='margin:0;background:#111;color:#fff'><h2>~w (vector)</h2><svg viewBox='0 0 800 450' width='100%%'><defs><linearGradient id='g'><stop offset='0%%' stop-color='#1b2a49'/><stop offset='100%%' stop-color='#f5b971'/></linearGradient></defs><rect width='800' height='450' fill='url(#g)'/><circle cx='620' cy='140' r='70' fill='#ffd86b' opacity='0.9'/><polygon points='280,310 420,260 420,330' fill='#10131a'/><animate attributeName='viewBox' values='0 0 800 450;20 0 780 450;0 0 800 450' dur='8s' repeatCount='indefinite'/></svg></body></html>", [Title]).
