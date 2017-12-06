%Ask the user for tournament score in the beginning of the tournament
ask_tscore(X) :-
    write('Enter Tournament Score (1-500): '), 
    read(N),
    integer(N),
    validate(N, 500),
    X = N, 
    nl.

ask_tscore(X) :-
    write('Wrong input. '), nl,
    ask_tscore(X).

%Ask the user to choose a tile from his/her hand
choose_tile(X, Hhand) :-
    write('Choose a tile to play from (1-'),
    length(Hhand, Length),
    write(Length),
    write('): '), 
    read(N),
    integer(N),
    validate(N, Length),
    X is N-1, 
    nl.


choose_tile(X, Hhand) :- 
    write('Wrong input. '), nl,
    choose_tile(X, Hhand).

validate(N, End) :- 
    N >= 1,  
    N =< End.

%To print the tile's contents
print_tile([]).
print_tile([First, Second | Rest]) :- 
    write(First), 
    write('-'), 
    write(Second), 
    write(' ').

%To print the conents of any list of tiles

print_list([]).
print_list([First | Rest]) :-
    print_tile(First),
    print_list(Rest).


%To print the state of the game
print_state(Hhand, Chand, Deck, Board) :-
    nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,
    write('Board:   L   '),
    print_list(Board),
    write('  R'),
    nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,
    write('Human hand:  '),
    print_list(Hhand), nl,
    write('Computer hand:  '),
    print_list(Chand), nl,
    write('Deck:  '),
    print_list(Deck), nl.


%Initialize and shuffle the deck
init_deck(Deck) :- 
    D = [[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],
            [1,1],[1,2],[1,3],[1,4],[1,5],[1,6],
            [2,2],[2,3],[2,4],[2,5],[2,6],
            [3,3],[3,4],[3,5],[3,6],
            [4,4],[4,5],[4,6],
            [5,5],[5,6],
            [6,6]],
    random_permutation(D, Deck).

%To draw the first tile from the deck
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
    init_hands(Hhand, Chand, D, 8),
    length(X, 16),
    append(X, Deck, D).

%To add a tile in a list
add_tile_left(List, Tile, [Tile|List]).
add_tile_right(List, Tile, NewList):-
    append(List, [Tile], NewList).

switch_pips([First|[Second|_]], [Second|[First]]).

%Remove tile at a specified index
remove_tile_at([],_,[]) :- write('Index out of bounds'), nl.
remove_tile_at([_|Rest], 0 , Rest) :- !.
remove_tile_at([First | Rest], N , [First | NewRest]) :-
    NewN is N-1,
    remove_tile_at(Rest, NewN, NewRest).

%Get a tile at a specified index
get_tile_at(Tile, Index, List):-
    nth0(Index, List, Tile).

check_placement(Tile, left, Board, NewTile) :-
    length(Board, L),
    L = 0,
    NewTile = Tile.

check_placement([Pip1|[Pip2|_]], left, Board, NewTile) :-
    get_tile_at([First|_], 0, Board),
    First = Pip2,
    NewTile = [Pip1|[Pip2]].

check_placement([Pip1|Pip2], left, Board, NewTile) :-
    get_tile_at([First|_], 0, Board),
    First = Pip1,
    switch_pips([Pip1|Pip2], NewTile).


check_placement([Pip1|Pip2], right, Board, NewTile) :-
    length(Board, L),
    Index is L - 1,
    get_tile_at([_|[Second|_]], Index , Board),
    Second = Pip1,
    NewTile = [Pip1|Pip2].

check_placement([Pip1|[Pip2|_]], right, Board, NewTile) :-
    length(Board, L),
    Index is L - 1,
    get_tile_at([_|[Second|_]], Index, Board),
    Second = Pip2,
    switch_pips([Pip1|[Pip2]], NewTile).

human_play(Hhand, Board, NewHand, NewBoard):-
    choose_tile(Index, Hhand),
    %NewIndex is Index - 1,
    get_tile_at(Tile, Index , Hhand),
    check_placement(Tile, left, Board, NewTile),
    remove_tile_at(Hhand, Index, NewHand),
    add_tile_left(Board, NewTile, NewBoard).

%human_play(Hhand, Board, NewHand, NewBoard):-
%    write('Invalid move.'), nl,
%    human_play(Hhand, Board, NewHand, NewBoard).

round(Hhand, Chand, Deck, Tscore) :- 
    init_game(Hhand, Chand, Deck, Tscore), 
    print_state(Hhand, Chand, Deck, []),
    round(Hhand,Chand, Deck, [], Tscore, 0).

round(Hhand, Chand, Deck, Board, Tscore, N) :-
    N < 10,
    human_play(Hhand, Board, NewHand, NewBoard),
    print_state(NewHand, Chand, Deck, NewBoard),
    NewN is N+1,
    round(NewHand, Chand, Deck, NewBoard, Tscore, NewN).

?- round(Hhand, Chand, Deck, Tscore). 

   %halt.

%?- ask_tscore(Tscore), write(Tscore), halt.