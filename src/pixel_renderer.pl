:- module(pixel_renderer, [render_pixel_movie/2]).

:- use_module(html_writer, [escape_html_text/2]).

render_pixel_movie(movie(Parts), HTML) :-
    member(title(Title), Parts),
    escape_html_text(Title, SafeTitle),
    html_template(SafeTitle, pixel, Frames, HTML),
    Frames = "<table class='pixel-frame'><tr><td class='sky'></td><td class='sun'></td><td class='sky'></td></tr><tr><td class='wave'></td><td class='ship'></td><td class='wave'></td></tr></table>".

html_template(Title, Mode, Body, HTML) :-
    format(string(HTML), "<html><head><style>body{background:#111;color:#eee;font-family:sans-serif}.pixel-frame td{width:18px;height:18px}.sky{background:#0e2b5c}.sun{background:#f7b733}.wave{background:#355c7d}.ship{background:#1a1a1a}@keyframes sway{0%{transform:translateX(0)}50%{transform:translateX(6px)}100%{transform:translateX(0)}}.pixel-frame{animation:sway 3s infinite}</style></head><body><h2>~s (~w)</h2><div id='movie'>~w</div></body></html>", [Title, Mode, Body]).
