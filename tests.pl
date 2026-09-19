:- initialization(main).

main :-
    consult('tests/tests.pl'),
    run_tests,
    halt.
