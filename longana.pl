
ask_tscore(X) :-
    write('Enter Tournament Score: '), 
    read(X), 
    nl.

print_tile([First, Second | Rest]) :- 
    write(First), 
    write('-'), 
    write(Second), 
    write(' ').

print_list([]).
print_list([First | Rest]) :-
    print_tile(First),
    print_list(Rest).

init_deck(Deck) :- 
    D = [[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],
            [1,1],[1,2],[1,3],[1,4],[1,5],[1,6],
            [2,2],[2,3],[2,4],[2,5],[2,6],
            [3,3],[3,4],[3,5],[3,6],
            [4,4],[4,5],[4,6],
            [5,5],[5,6],
            [6,6]],
    random_permutation(D, Deck).

add_tile(List, Tile, NewList):-
    append(Tile, List, NewList).

draw(Tile, [First | Rest], NewDeck):-
    Tile = First,
    NewDeck = Rest.

%Initialize the hands of the players
init_hands([], [], _ , 0).
init_hands([First | HNewRest], [Second | CNewRest], [First, Second | Rest], N) :-
    NewN is N-1,
    init_hands(HNewRest, CNewRest, Rest, NewN).

%Initialize a round
init_game(Hhand, Chand, Deck, Tscore):-
    ask_tscore(Tscore),
    init_deck(D),
    %write(D), nl,
    init_hands(Hhand, Chand, D, 8),
    length(X, 16),
    append(X, Deck, D).


?- init_game(Hhand, Chand, Deck, Tscore), 
            print_list(Hhand),
            halt.
%?- ask_tscore(Tscore), write(Tscore), halt.