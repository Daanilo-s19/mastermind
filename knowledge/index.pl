:- dynamic alreadyGuessed/1.
    
% possiveis cores
colors([1,2,3,4,5,6]).

% usa seed fixa para ser previsivel nos testes
random(100).

% inicialização
% mastermind(-Saida)
mastermind(Out) :-
    FirstGuess = [1,2,3,4],
    mastermind(FirstGuess, [5,6], [], [], Out).

% mastermind(+Chute, +CoresDeSaida, +Certezas, +Incertezas, -NovoChute)
mastermind(Guess, OutColors, Certain, Uncertain, Out) :-
    ask(Guess, ColorPlaced, ColorOnSolution),
    (ColorPlaced = 4
     -> true, !;
    	assert(alreadyGuessed(Guess)),
    	CurrentState= [Guess, OutColors, Certain, Uncertain],
        Sum is ColorPlaced + ColorOnSolution,
    	query_guess(Sum, CurrentState, Results),
        [NewGuess, NewOutColors, NewCertain, NewUncertain] = Results,
    	mastermind(NewGuess, NewOutColors, NewCertain, NewUncertain, Out)).

% pergunta pelo feedback
% ask(+Chute, -CorEmLugarCorreto, -CorEmLugarIncorreto)
ask(Guess, ColorPlaced, ColorOnSolution) :-
	write(Guess), nl,
	write('Entre com a quantidade de números em posição correta:'),
    read(ColorPlaced),
    write('Entre com a quantidade de números mal posicionados:'),
    read(ColorOnSolution), nl.
    
% se a soma for 4, basta chutar entre as cores do chute
% query_guess(4, +Parametros, -NovoEstado)
query_guess(4, Params, Out) :-
    [Guess, OutColors|_] = Params,
    append(Guess, OutColors, CanBeGuess),
	generator(CanBeGuess, NewGuess),
    Out = [NewGuess, [], [], []].

% se a soma for 0, basta pegar todas as cores de fora e chutá-las
% query_guess(4, +Parametros, -NovoEstado)
query_guess(0, Params, Out) :-
    [Guess,OutColors|_] = Params,
    list_to_set(OutColors, SetInColors),
    colors(EveryColors),
    subtract(EveryColors, SetInColors, SetOutColors),
    concat_n(SetInColors, 3, Result),
    get4_elements(Result, NewGuess),
    Out = [NewGuess, SetInColors, SetOutColors, Guess].

% concat_n(+ListaDeEntrada, +NumeroDeRepeticoes, -ListaDeSaida)
concat_n(_, 0, _).
concat_n(Lin, N, Lout) :-
    append(Lin, Lin, Lout),
    NN is N-1,
    concat_n(Lin, NN, Lout).

% get4_elements(+ListaEntrada, -Saida)
get4_elements(L, [A,B,C,D]) :-
    length(L, Size), Size > 3,
    nth0(0, L, A), nth0(1, L, B),
    nth0(2, L, C), nth0(3, L, D).

generator(Colors, [A,B,C,D]) :-
    member(A,Colors), member(B,Colors),
    member(C,Colors), member(D,Colors),
    L = [A,B,C,D],
    not(alreadyGuessed(L)), !;
    L = [A,B,C,D],
    generator(Colors, L).