%Ask the user for tournament score in the beginning of the tournament
ask_tscore(X) :-
    write('Enter Tournament Score: '), 
    read(X), 
    nl.

%Ask the user to choose a tile from his/her hand
choose_tile(X, Hhand) :-
    write('Choose a tile to play from (1-'),
    len(Hhand, Length),
    write(Length),
    write('): '), 
    read(N),
    X is N-1,  
    nl.

%To find the length of any list 
len([], LenResult):-
    LenResult is 0.
len([First | Rest], LenResult):-
    len(Rest, L),
    LenResult is L + 1.

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

%To add a tile in a list
add_tile(List, Tile, NewList):-
    append(List, [Tile], NewList).

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

%Play a tile at a specified index
play_tile_at(Tile, Hhand, Index, NewHand):-
    get_tile_at(Tile, Index, Hhand),
    remove_tile_at(Hhand, Index, NewHand).
    %remove_tile_at(Hand, Index, NewHand).


%Remove tile at a specified index
remove_tile_at([],_,[]) :- write('Index out of bounds'), nl.
remove_tile_at([_|Rest], 0 , Rest) :- !.
remove_tile_at([First | Rest], N , [First | NewRest]) :-
    NewN is N-1,
    remove_tile_at(Rest, NewN, NewRest).

%Get a tile at a specified index
get_tile_at(Tile, Index, List):-
    nth0(Index, List, Tile).

human_play(Hhand, Board, NewHand, NewBoard):-
    choose_tile(Index, Hhand),
    play_tile_at(Tile, Hhand, Index, NewHand),
    add_tile(Board, Tile, NewBoard).

round(Hhand, Chand, Deck, Tscore) :- 
    init_game(Hhand, Chand, Deck, Tscore), 
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