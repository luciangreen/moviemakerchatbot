:- module(rendered_renderer, [render_rendered_movie/2]).

:- use_module(html_writer, [escape_html_text/2]).

render_rendered_movie(movie(Parts), HTML) :-
    member(title(Title), Parts),
    escape_html_text(Title, SafeTitle),
    format(string(HTML), "<html><body style='margin:0;background:#000;color:#fff'><h2 style='padding:12px'>~s (rendered)</h2><canvas id='c' width='800' height='450'></canvas><script>const c=document.getElementById('c');const x=c.getContext('2d');let t=0;function f(){t+=0.02;x.fillStyle='rgba(0,0,0,0.2)';x.fillRect(0,0,800,450);const g=x.createLinearGradient(0,0,0,450);g.addColorStop(0,'#10213e');g.addColorStop(1,'#f2994a');x.fillStyle=g;x.fillRect(0,0,800,450);x.fillStyle='rgba(255,210,120,0.85)';x.beginPath();x.arc(650,120,70,0,Math.PI*2);x.fill();x.fillStyle='#101014';x.beginPath();x.moveTo(280+t*35%%300,310);x.lineTo(420+t*35%%300,260);x.lineTo(420+t*35%%300,330);x.closePath();x.fill();requestAnimationFrame(f)}f();</script></body></html>", [SafeTitle]).
