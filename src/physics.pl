:- module(physics, [next_state/3]).

next_state(state{position:(X,Y),velocity:(VX,VY),acceleration:(AX,AY)}, Dt,
           state{position:(NX,NY),velocity:(NVX,NVY),acceleration:(AX,AY)}) :-
    NVX is VX + AX*Dt,
    NVY is VY + AY*Dt,
    NX is X + NVX*Dt,
    NY is Y + NVY*Dt.
