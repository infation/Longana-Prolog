
%Ask the user to choose a tile from his/her hand
choose_tile(X, Hhand) :-
    write('Choose a tile to play from (1-'),
    length(Hhand, Length),
    write(Length),
    write('): '), 
    read(N),
    integer(N),
    validate(N, Length),
    X is N-1.


choose_tile(X, Hhand) :- 
    write('Wrong tile input. '), nl,
    choose_tile(X, Hhand).

validate(N, End) :- 
    N >= 1,  
    N =< End.

%Ask the user for tournament score in the beginning of the tournament
ask_tscore(X) :-
    write('Enter Tournament Score (1-500): '), 
    read(N),
    integer(N),
    validate(N, 500),
    X = N.

ask_tscore(X) :-
    write('Wrong Tournament score input. '), nl,
    ask_tscore(X).


ask_for_help(X):-
    write('Do you want a hint (yes/no)? : '),
    read(N),
    validate_help(N),
    X = N.

ask_for_help(X):-
    write('Wrong help input. '),nl,
    ask_for_help(X).

validate_help(yes).
validate_help(no).

ask_side_placement(X, Tile, _) :-
    is_double(Tile),
    write('Do you want to place it on the (left/right)? : '),
    read(N),
    validate_side(N),
    X = N.

ask_side_placement(X, _, IsPassed) :-
    IsPassed,
    write('Do you want to place it on the (left/right)? : '),
    read(N),
    validate_side(N),
    X = N.

ask_side_placement(X, Tile ,IsPassed):- 
    not(is_double(Tile)),
    not(IsPassed),
    X = left.

validate_side(left).
validate_side(right).



%To print the tile's contents
print_tile([]).
print_tile([First, Second | _]) :- 
    write(' '),
    write(First), 
    write('-'), 
    write(Second), 
    write(' ').

%To print the conents of any list of tiles

print_list([]).
print_list([First | Rest]) :-
    print_tile(First),
    print_list(Rest).

print_doubles([]).
print_doubles([[Pip1, Pip2|_]|Rest]):-
    is_double([Pip1|[Pip2]]),
    write(Pip1),
    print_doubles(Rest).


print_doubles([_|Rest]):-
    write('     '),
    print_doubles(Rest). 

print_normals([]).
print_normals([Tile|Rest]):-
    not(is_double(Tile)),
    print_tile(Tile),
    print_normals(Rest).

print_normals([_|Rest]):-
    write('|'),
    print_normals(Rest).

print_board(Board):-
   nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,
   write('============================================================================================================='),nl,
   write('============================================================================================================='),nl,nl,
   write('              '),
   print_doubles(Board), nl,
   write('BOARD:     L  '),
   print_normals(Board), 
   write('  R'), nl,
   write('              '),
   print_doubles(Board), nl,nl,
   write('============================================================================================================='),nl,
   write('============================================================================================================='),nl,
%    print_list(Board),
 %   write('  R'),
   nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl.

%To print the state of the game
print_state(Hhand, Chand, Deck, Board) :-
    print_board(Board),
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

draw(_, [], []):-fail.

%Initialize the hands of the players
init_hands([], [], _ , 0).
init_hands([First | HNewRest], [Second | CNewRest], [First, Second | Rest], N) :-
    NewN is N-1,
    init_hands(HNewRest, CNewRest, Rest, NewN).

%Initialize a round
init_game(Hhand, Chand, Deck):-
    init_deck(D),
    init_hands(Hhand, Chand, D, 8),
    length(X, 16),
    append(X, Deck, D).




%To add a tile in a list
add_tile(List, left, Tile, [Tile|List]).
add_tile(List, right, Tile, NewList):-
    append(List, [Tile], NewList).
add_tile(List, _, Tile, [Tile|List]).



switch_pips([First|[Second|_]], [Second|[First]]).
is_double([Pip1 | [Pip2|_]]):- Pip1 = Pip2.
sum_tile([Pip1|[Pip2|_]], Sum):-
    Sum is Pip1 + Pip2.

%Remove tile at a specified index
remove_tile_at([],_,[]) :- write('Index out of bounds'), nl.
remove_tile_at([_|Rest], 0 , Rest) :- !.
remove_tile_at([First | Rest], N , [First | NewRest]) :-
    NewN is N-1,
    remove_tile_at(Rest, NewN, NewRest).

%Get a tile at a specified index
get_tile_at(Tile, Index, List):-
    nth0(Index, List, Tile).




check_placement(Tile, _, Board, NewTile) :-
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


check_both_sides(Tile, Board):- check_placement(Tile, _, Board, _).

sum_hand([], 0).
sum_hand([First|Rest], Sum):-    
    sum_hand(Rest, NewSum),
    sum_tile(First, TileSum),
    Sum is NewSum + TileSum.

is_move_possible(Tile, _, Board, _):-
    is_double(Tile),
    check_both_sides(Tile, Board).

is_move_possible(Tile, _, Board, IsPassed):-
    IsPassed,
    check_both_sides(Tile, Board).

is_move_possible(Tile, Side, Board, _):-
    check_placement(Tile, Side, Board, _).



check_available_moves([], _, _, _):- fail.
check_available_moves([Tile|_], Board, Side, IsPassed):-
    is_move_possible(Tile, Side, Board, IsPassed),
    print(Tile).

check_available_moves([_|Rest], Board, Side, IsPassed):-
    check_available_moves(Rest, Board, Side, IsPassed).   

get_help(Hhand, Board, IsPassed, yes):-
    computer_decision(Hhand, Board, Side, IsPassed, Index, 0, left),
    get_tile_at(Tile, Index , Hhand),
    write('Computer suggests playing '),
    print_tile(Tile),
    write('on the '),
    write(Side),
    write(' using the first available tile that could find method.'),nl.

get_help(_,_,_,no).

computer_decision([], _, _, _, _, _,_):- fail.

computer_decision([Tile|_], Board, Side, IsPassed, Index, N, _):-
    IsPassed,
    check_placement(Tile, left, Board, _),    
    Index = N,
    Side = left.


computer_decision([Tile|_], Board, Side, _, Index, N,_):-
    is_double(Tile),
    check_placement(Tile, left, Board, _),
    Index = N,
    Side = left.

computer_decision([Tile|_], Board, Side, IsPassed, Index, N,_):-
    IsPassed,
    check_placement(Tile, right, Board, _),    
    Index = N,
    Side = right.


computer_decision([Tile|_], Board, Side, _, Index, N , _):-
    is_double(Tile),
    check_placement(Tile, right, Board, _),
    Index = N,
    Side = right.    

computer_decision([Tile|_], Board, Side, _, Index, N, MainSide):-
    check_placement(Tile, MainSide, Board, _),
    Index = N,
    Side = MainSide.

computer_decision([_|Rest], Board, Side, IsPassed, Index, N, MainSide):-
    NewN is N + 1,
    computer_decision(Rest, Board, Side, IsPassed, Index, NewN, MainSide).
%computer_play(Chand, Board).

validate_move(Hhand, Board, CompPassed, NewHand, NewBoard):-
    choose_tile(Index, Hhand),
    get_tile_at(Tile, Index , Hhand),
    is_move_possible(Tile, _, Board, CompPassed),
    ask_side_placement(Side, Tile, CompPassed),
    check_placement(Tile, Side, Board, NewTile),
    remove_tile_at(Hhand, Index, NewHand),
    add_tile(Board, Side, NewTile, NewBoard).

validate_move(Hhand, Board, CompPassed, NewHand, NewBoard) :-
    write('Wrong placement'),
    validate_move(Hhand, Board, CompPassed, NewHand, NewBoard).


human_play(Hhand, Board, Deck,  CompPassed, NewHand, NewBoard, NewDeck, HumanPassed):-
    check_available_moves(Hhand, Board, left, CompPassed),
    ask_for_help(Ans),
    get_help(Hhand, Board, CompPassed, Ans),
    validate_move(Hhand, Board, CompPassed, NewHand, NewBoard),
    HumanPassed = fail,
    NewDeck = Deck.

human_play(Hhand, Board, Deck , CompPassed, NewHand, NewBoard, NewDeck, HumanPassed):-
    draw(Tile, Deck, NewDeck),
    write('No available moves, Drawing tile from the deck'), nl,
    write('You drew: '), print_tile(Tile), nl,
    add_tile(Hhand, right, Tile, N),
    write('New hand: '), print_list(N), nl,
    check_available_moves(N, Board, left, CompPassed),
    ask_for_help(Ans),
    get_help(N, Board, CompPassed, Ans),
    validate_move(N, Board, CompPassed, NewHand, NewBoard),
    HumanPassed = fail. 

human_play(Hhand,Board,Deck,_,NewHand,NewBoard,NewDeck,HumanPassed):-
    draw(Tile, Deck, NewDeck),
    write('You couldnt play the drawn tile.'),
    add_tile(Hhand, right, Tile, NewHand),
    NewBoard = Board,
    HumanPassed = true.

human_play(Hhand,Board,Deck,_,Hhand,Board,Deck,true):-
    write('You cant play anything and there are no more tiles in the deck').
   
%human_play(Hhand, Board, NewHand, NewBoard):-
%    write('Invalid move.'), nl,
%    human_play(Hhand, Board, NewHand, NewBoard).
computer_play(Chand, Board, Deck,  HumanPassed, NewHand, NewBoard, NewDeck, CompPassed):-
    computer_decision(Chand, Board, Side, HumanPassed, Index, 0, right),
    %write('Index: '), write(Index), nl,
    get_tile_at(Tile, Index , Chand),
    check_placement(Tile, Side, Board, NewTile),
    write('Computer placed '),
    print_tile(NewTile), 
    write(' on the '),
    write(Side),
    write(' using the first available tile that could find method.'),nl,
    remove_tile_at(Chand, Index, NewHand),
    add_tile(Board, Side, NewTile, NewBoard),
    CompPassed = fail,
    NewDeck = Deck.

computer_play(Chand, Board, Deck, HumanPassed, NewHand, NewBoard, NewDeck, CompPassed):-
    draw(Tile, Deck, NewDeck),
    write('No available moves, Drawing tile from the deck'), nl,
    write('Computer drew: '), print_tile(Tile), nl,
    add_tile(Chand, right, Tile, N),
    computer_decision(N, Board, Side, HumanPassed, Index, 0, right),
    check_placement(Tile, Side, Board, NewTile),
    write('Computer placed '),
    print_tile(NewTile), 
    write(' on the '),
    write(Side),
    write(' using the first available tile that could find.'),nl,
    remove_tile_at(N, Index, NewHand),
    add_tile(Board, Side, NewTile, NewBoard),
    CompPassed = false.

computer_play(Chand,Board,Deck,_,NewHand,NewBoard,NewDeck,CompPassed):-
    %print_list(Chand),nl,
    draw(Tile, Deck, NewDeck),
    write('Computer couldnt play the drawn tile.'),nl,
    add_tile(Chand, right, Tile, NewHand),
    NewBoard = Board,
    CompPassed = true.

computer_play(Chand,Board,Deck,_,Chand,Board,Deck,true):- 
    write('Computer cant play anything and there are no more tiles in the deck').



check_for_round_ending(Hhand, Chand, _, _, _, Hscore, Cscore, Tscore, RoundNum):-
    length(Hhand, L),
    L = 0,
    sum_hand(Chand, Score),
    NewHscore is Hscore + Score,
    nl,nl,nl,nl,nl,nl,nl,
    write('Human won the round with score '), 
    write(Score), nl, 
    write('Human Tournament Score: '),
    write(NewHscore),nl,
    write('Computer Tournament Score: '),
    write(Cscore), nl,
    NewRoundNum is RoundNum + 1,
    round(_,_,_,Tscore, NewHscore, Cscore, NewRoundNum),
    halt.

check_for_round_ending(Hhand, Chand, _, _, _,  Hscore, Cscore, Tscore, RoundNum):-
    length(Chand, L),
    L = 0,
    sum_hand(Hhand, Score),
    NewCscore is Cscore + Score,
    nl,nl,nl,nl,nl,nl,nl,
    write('Computer won the round with score '), 
    write(Score),nl,
    write('Human Tournament Score: '),
    write(Hscore),nl,
    write('Computer Tournament Score: '),
    write(NewCscore), nl,
    NewRoundNum is RoundNum + 1,
    round(_,_,_,Tscore, Hscore, NewCscore, NewRoundNum),
    halt.

check_for_round_ending(Hhand, Chand, HumanPassed, CompPassed, Deck, Hscore, Cscore, Tscore, RoundNum):-
    length(Deck, L),
    L = 0,
    HumanPassed,
    CompPassed,
    decide_winner(Hhand, Chand, Hs, Cs),
    NewHscore is Hscore + Hs,
    NewCscore is Cscore + Cs,
    write('Human Tournament Score: '),
    write(NewHscore),nl,
    write('Computer Tournament Score: '),
    write(NewCscore), nl,
    NewRoundNum is RoundNum + 1, 
    round(_,_,_,Tscore, NewHscore, NewCscore, NewRoundNum),
    halt.

decide_winner(Hhand, Chand, Hscore, Cscore):-
    sum_hand(Hhand, NewHscore),
    sum_hand(Chand, NewCscore),
    NewHscore < NewCscore,
    nl,nl,nl,nl,nl,nl,nl,
    write('Human won the round with score '),
    write(NewCscore), nl,
    Hscore = NewCscore,
    Cscore = 0.

decide_winner(Hhand, Chand, Hscore, Cscore):-
    sum_hand(Hhand, NewHscore),
    sum_hand(Chand, NewCscore),
    NewHscore > NewCscore,
    nl,nl,nl,nl,nl,nl,nl,
    write('Computer won the round with score '), 
    write(NewHscore), nl,
    Cscore = NewHscore,
    Hscore = 0.

decide_winner(Hhand, Chand, Hscore, Cscore):-
    sum_hand(Hhand, NewHscore),
    sum_hand(Chand, NewCscore),
    NewHscore = NewCscore,
    nl,nl,nl,nl,nl,nl,nl,
    write('The round ended with a draw.'),nl,
    Hscore = 0,
    Cscore = 0.

check_for_tournament_ending(Hscore, Cscore, Tscore):-
    Hscore >= Tscore,
    nl,nl,nl,nl,nl,nl,nl,
    write('Human Tournament Score: '),
    write(Hscore),nl,
    write('Computer Tournament Score: '),
    write(Cscore), nl,
    write('Tournament Winner: Human'), nl,
    halt.

check_for_tournament_ending(Hscore, Cscore, Tscore):-
    Cscore >= Tscore,
    nl,nl,nl,nl,nl,nl,nl,
    write('Human Tournament Score: '),
    write(Hscore),nl,
    write('Computer Tournament Score: '),
    write(Cscore), nl,
    write('Tournament Winner: Computer'), nl,
    halt.



calculate_engine(RoundNum, Engine):-
    Test is mod(RoundNum,7),
    not(Test = 0),
    Engine is 7 - mod(RoundNum,7).

calculate_engine(RoundNum, Engine):-
    Test is mod(RoundNum,7),
    Test = 0,
    Engine = 0.




tournament :-
    RoundNum = 1,
    ask_tscore(Tscore),
    round(_,_,_,Tscore,0,0, RoundNum).


look_for_engine([], _,_, _) :- fail.
look_for_engine([[Pip1, Pip2 | _]|_], Engine, Index, N):-
    Pip1 = Engine,
    Pip2 = Engine, 
    Index is N.

look_for_engine([_|Rest], Engine, Index, N) :-
    NewN is N+1,
    look_for_engine(Rest, Engine, Index, NewN).


draw_engine(Hhand, Chand, Deck, Engine, NewHhand, NewChand, NewDeck, NewBoard, Turn):-
    look_for_engine(Hhand, Engine, Index, 0),
    write('Human has the engine.'),nl,
    get_tile_at(Tile, Index, Hhand),
    remove_tile_at(Hhand, Index, NewHhand),
    Turn = computer,
    NewBoard = [Tile],
    NewChand = Chand,
    NewDeck = Deck.

draw_engine(Hhand, Chand, Deck, Engine, NewHhand, NewChand, NewDeck, NewBoard, Turn):-
    look_for_engine(Chand, Engine, Index, 0),
    write('Computer has the engine.'),nl,
    get_tile_at(Tile, Index, Chand),
    remove_tile_at(Chand, Index, NewChand),
    Turn = human,
    NewBoard = [Tile],
    NewHhand = Hhand,
    NewDeck = Deck.

draw_engine(Hhand, Chand, Deck, Engine, NewHhand, NewChand, NewDeck, NewBoard, Turn):-
    draw(Tile, Deck, N),
    add_tile(Hhand, right, Tile, NHhand),
    draw(NewTile, N, NDeck),
    add_tile(Chand, right, NewTile, NChand),
    write('Engine not found...Drawing tiles from the deck.'),nl,
    draw_engine(NHhand, NChand, NDeck, Engine, NewHhand, NewChand, NewDeck, NewBoard, Turn).

round(Hhand, Chand, Deck, Tscore, Hscore, Cscore, RoundNum) :-
    calculate_engine(RoundNum, Engine),
    nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,
    not(check_for_tournament_ending(Hscore, Cscore, Tscore)),
    init_game(Hhand, Chand, Deck), 
    draw_engine(Hhand, Chand, Deck, Engine, NewHhand, NewChand, NewDeck, NewBoard, Turn),
    print_state(NewHhand, NewChand, NewDeck, NewBoard),
    round(NewHhand,NewChand, NewDeck, NewBoard, fail, fail, Tscore, Hscore, Cscore, RoundNum, Turn).

round(Hhand, Chand, Deck, Board, CompPassed, HumanPassed, Tscore, Hscore, Cscore, RoundNum, human) :-
    
    not(check_for_round_ending(Hhand, Chand, CompPassed, HumanPassed, Deck, Hscore, Cscore, Tscore, RoundNum)),
    
    human_play(Hhand, Board, Deck, CompPassed, NewHhand, NewBoard, NewDeck, NewHumanPassed),
    not(check_for_round_ending(NewHhand, Chand, CompPassed, NewHumanPassed, NewDeck, Hscore, Cscore, Tscore, RoundNum)),
    print_state(NewHhand, Chand, NewDeck, NewBoard),
    
    computer_play(Chand, NewBoard, NewDeck, NewHumanPassed, NewChand, NBoard, NDeck, NewCompPassed),
    not(check_for_round_ending(NewHhand, NewChand, NewCompPassed, NewHumanPassed, NDeck, Hscore, Cscore, Tscore, RoundNum)),
    print_state(NewHhand, NewChand, NDeck, NBoard),
    
    round(NewHhand, NewChand, NDeck, NBoard, NewCompPassed, NewHumanPassed, Tscore, Hscore, Cscore, RoundNum, human).


round(Hhand, Chand, Deck, Board, CompPassed, HumanPassed, Tscore, Hscore, Cscore, RoundNum, computer) :-
   
    not(check_for_round_ending(Hhand, Chand, CompPassed, HumanPassed, Deck, Hscore, Cscore, Tscore, RoundNum)),
    
    computer_play(Chand, Board, Deck, HumanPassed, NewChand, NewBoard, NewDeck, NewCompPassed),
    not(check_for_round_ending(Hhand, NewChand, NewCompPassed, HumanPassed, NewDeck, Hscore, Cscore, Tscore, RoundNum)),
    print_state(Hhand, NewChand, NewDeck, NewBoard),

    human_play(Hhand, NewBoard, NewDeck, NewCompPassed, NewHhand, NBoard, NDeck, NewHumanPassed),
    not(check_for_round_ending(NewHhand, NewChand, NewCompPassed, NewHumanPassed, NDeck, Hscore, Cscore, Tscore, RoundNum)),
    print_state(NewHhand, NewChand, NDeck, NBoard),
    
   
    round(NewHhand, NewChand, NDeck, NBoard, NewCompPassed, NewHumanPassed, Tscore, Hscore, Cscore, RoundNum, computer).


?- tournament.
%?- round(_,_,_,_, 0, 0). 

   %halt.

%?- ask_tscore(Tscore), write(Tscore), halt.