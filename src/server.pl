:- module(server, [start_server/1, stop_server/0]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/html_write)).
:- use_module(chatbot).
:- use_module(movie_maker).

:- dynamic server_port/1.

:- http_handler(root(.), home_page, []).
:- http_handler(root(api/generate), api_generate, [method(post)]).
:- http_handler(root(api/regenerate), api_regenerate, [method(post)]).

start_server(Port) :-
    http_server(http_dispatch, [port(Port)]),
    retractall(server_port(_)),
    assertz(server_port(Port)).

stop_server :-
    server_port(Port),
    http_stop_server(Port, []),
    retractall(server_port(_)).

home_page(_Request) :-
    reply_html_page(
        title('Movie Maker Web Chatbot'),
        [ \page_body ]).

page_body -->
    html(div([style('font-family:sans-serif;max-width:900px;margin:20px auto')], [
        h1('Movie Maker Web Chatbot'),
        p('Enter a sentence and generate a cinematic web movie.'),
        textarea([id(spec),rows(3),style('width:100%')], 'A sailing ship crosses a golden ocean at sunset.'),
        div([], [
            label([for(style)], 'Visual style'),
            select([id(style)], [
                option([value(pixel)], 'pixel'),
                option([value(vector)], 'vector'),
                option([value(rendered)], 'rendered')
            ]),
            label([for(duration), style('margin-left:10px')], 'Duration'),
            input([id(duration),type(number),value(20),min(4),max(120)], [])
        ]),
        div([style('margin-top:10px')], [
            button([onclick('generateMovie()')], 'Generate Movie'),
            button([onclick('regenerateMovie()'), style('margin-left:8px')], 'Regenerate')
        ]),
        p([], [
            'Edit instructions: ',
            input([id(edit),type(text),value('Make the ending peaceful.'),style('width:70%')],[])
        ]),
        pre([id(reply),style('white-space:pre-wrap;background:#f5f5f5;padding:8px')], ''),
        div([id(preview),style('border:1px solid #ddd;min-height:120px')], '')
    ])),
    html(script(type('text/javascript'),
"let latestMovie=null;
async function generateMovie(){
  const payload={sentence:document.getElementById('spec').value,style:document.getElementById('style').value,duration:parseInt(document.getElementById('duration').value,10)};
  const r=await fetch('/api/generate',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(payload)});
  const j=await r.json();
  latestMovie=j.movie;
  document.getElementById('reply').textContent=j.message;
  document.getElementById('preview').innerHTML=j.html;
}
async function regenerateMovie(){
  const payload={
    instruction:document.getElementById('edit').value,
    sentence:document.getElementById('spec').value,
    style:document.getElementById('style').value,
    duration:parseInt(document.getElementById('duration').value,10),
    target:'scene(4)'
  };
  const r=await fetch('/api/regenerate',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(payload)});
  const j=await r.json();
  latestMovie=j.movie;
  document.getElementById('reply').textContent='Updated movie scene instructions.';
}
" )).

api_generate(Request) :-
    http_read_json_dict(Request, Dict),
    Sentence = Dict.get(sentence),
    StyleRaw = Dict.get(style),
    ( string(StyleRaw) -> atom_string(Style, StyleRaw) ; Style = StyleRaw ),
    Duration = Dict.get(duration),
    chatbot_reply(Sentence, [style(Style), duration(Duration)], response(Message, Movie, HTML)),
    term_string(Movie, MovieSpec),
    reply_json_dict(_{message:Message,movie:MovieSpec,html:HTML}).

api_regenerate(Request) :-
    http_read_json_dict(Request, Dict),
    Instruction = Dict.get(instruction),
    Sentence = Dict.get(sentence),
    StyleRaw = Dict.get(style),
    ( string(StyleRaw) -> atom_string(Style, StyleRaw) ; Style = StyleRaw ),
    Duration = Dict.get(duration),
    movie(Sentence, [style(Style), duration(Duration)], Movie0),
    atom_to_term('scene(4)', Target, _),
    regenerate(Target, Instruction, Movie0, Movie1),
    term_string(Movie1, MovieSpec),
    reply_json_dict(_{movie:MovieSpec}).
