:- module(html_writer, [movie_assets/3]).

movie_assets(HTML, css("body{margin:0}"), js("console.log('movie loaded')")) :- string(HTML).
