:- dynamic solutionDigits/1.
:- dynamic  outSolutionDigits/1.
:- dynamic orderAlreadyKicked/1.

% assert inserir no final da base
% asserta inserir no inicio da base
% listing lista um predicado
% retract/1  removE a primeiras clï¿½sulas

solutionDigits(). % predicado para armazenar os digitos presenta na solução 
outSolutionDigits(). % predicado para armazenar os digitos que não estão presenta na solução 
orderAlreadyKicked(). % predicado para armazenar uma lista de chutes 

%addSolutionDigits(Digit):- assert(solutionDigits(Digit)).

%addSolutionDigits(Variavel, ListaParaAdicionar)
addSolutionDigits(X,[Z|Y]):- 
                assert(solutionDigits(Z)), % inseri o valor na base de digitos da solução 
                addSolutionDigits(X,Y). %recursão


addOutSolutionDigits(X,[Z|Y]):-
                assert(outSolutionDigits(Z)), %inseri o valor na base de digitos que não na solução 
                addOutSolutionDigits(X,Y). %recursão

addOrderAlreadyKicked(Ordem):-
                assert(orderAlreadyKicked(Ordem)). %inseri uma ordem que já foi chutada na base


listSolutionDigits(R) :- % retorna no formato de lista todos os digitos que pertence a solução  
        findall(Y, solutionDigits(Y), R). 

listOutSolutionDigits(R) :- % retorna no formato de lista todos os digitos que não pertece a solução 
        findall(Y, outSolutionDigits(Y), R).


% Apagar todos predicado das ordem ja chutadas que estÃ£o na solucao 
removeOrderAlreadyKicked(X):-
                    retract(orderAlreadyKicked(X)),
                    removeOrderAlreadyKicked(X).

% Apagar todos predicado  dos digitos que estÃ£o na soluÃ§Ã£o
removeAllSolutionDigits(X):-
                    retract(solutionDigits(X)),
                    removeAllSolutionDigits(X).

%% apagar todos predicado  dos digitos que nÃ£o estÃ£o na soluÃ§Ã£o
removeAllOutSolutionDigits(X):-
        retract(outSolutionDigits(X)),
        removeAllOutSolutionDigits(X).

clearBase(X):- removeAllOutSolutionDigits(X),
               removeAllSolutionDigits(X),
               removeOrderAlreadyKicked(X).


%removeList(X, [X | C], C).
%removeList(X, [Y | C], [Y | D]):- removeList(X,C,D).

%addList(X,Y,[X|Y]).

%  estrutura do if else : if(CondiÃ§Ã£o, se verdade, se falso)
if(Condition,Then,_Else):- Condition, !, Then.
if(_,_,Else):- Else.

%chamada incial do jogo 
mastermind(Out) :-
    not(clearBase(Out)),
    FirstKick = [1,2,3,4], % primeiro chute
    DigitsOut = [5,6], % digitos fora do chute
    mastermind(FirstKick,DigitsOut, Out). 

% mastermind(Chute , DigitosForaDoChute, variavel).
mastermind(Kick, DigitsOut, Out) :-
    feedback(Kick, Certain, IncorrectPosition),
    win( Certain , IncorrectPosition, Kick, DigitsOut, Out).


%feedback(Chute, QtDigitoscerto, QtDigitosCertoNaPosicaoErrada)
feedback(Kick, Certain, IncorrectPosition) :-
	write(Kick), nl, % apresenta o chute 
	write('Entre com a quantidade de numeros em posicao correta:'), 
        readln(Certain), % leitura 
        write('Entre com a quantidade de numeros mal posicionados:'),
        readln(IncorrectPosition), nl. % leitura 




win( Certain , IncorrectPosition,Kick, DigitsOut,Out):- % teste de vitoria, caso vença com chute aleatorio
                        Certain =:= 4 , IncorrectPosition =:= 0,
                        write('Venceu'), write(Kick).


win( Certain , IncorrectPosition, Kick,DigitsOut, Out):- % teste de vitoria falhou, segue para validacao!
                        Certain =\= 4 ,
                        Sume is Certain + IncorrectPosition,
                        validation(Kick,Sume,DigitsOut, Out).

win(Certain, IncorrectPosition, Kick):- % testa de venceu com sucesso 
                        Certain =:= 4 , IncorrectPosition =:= 0,
                        write('Venceu'), write(Kick).

win(Certain, IncorrectPosition, Kick):- % teste de vitoria falhou, segue!
                        Certai =\= 4.
                       

                % write(' ----- 4 ').

validation(Kick,Sume,DigitsOut,Out):-
                Sume =:= 4,
                write('sume = 4'),
                not(addSolutionDigits(Out,Kick)),
                not(addOutSolutionDigits(Out,DigitsOut)),
                addOrderAlreadyKicked(Kick),
                listOutSolutionDigits(FilterSet),
                accurateKick(FilterSet, Out).


validation(Kick,Sume,DigitsOut,Out):-
                Sume =:= 3 ,
                write('Sume igual = 3').
               % addOrderAlreadyKicked(Kick),
               % addSolutionDigits(DigitsOut),
                %newKick(Kick,  Out).

validation(Kick,Sume,DigitsOut,Out):-
        Sume =:= 2 ,
        write('Sume igual 2').
        

validation(Kick,Sume,DigitsOut,Out):-
         Sume =:= 1 ,
         write('Sume igual 1').
        


validation(Kick,Sume,DigitsOut,Out):-
                Sume =:= 0 ,
                write('sume = 0'),
                not(addSolutionDigits(Out,Kick)),
                not(addOutSolutionDigits(Out,Kick)),
                addOrderAlreadyKicked(Kick),
                listOutSolutionDigits(FilterSet),
                accurateKick(FilterSet, Out).


validation(Kick,Sume,Out):-
        Sume > 4 ,
        write('Feedback InvÃ¡lido'),
        Kick is 0, Out is 0.


accurateKick(FilterSet, NewKick):-
        gera_codigo(FilterSet,NewKick),
        %vericar se jï¿½ foi realizado o chute.
        if(orderAlreadyKicked(NewKick),accurateKick(FilterSet, _), addOrderAlreadyKicked(NewKick)),
        feedback(NewKick, Certain, IncorrectPosition),
        % win(Certain,IncorrectPosition,NewKick),
        Sume2 is Certain + IncorrectPosition,
        if(Sume2 =:= 4 , accurateKick(FilterSet,_),write( 'Feedback incoerente')).

%ConjuntoFiltros, +ListaSaida
newKick(FilterSet, NewKick):-
        gera_codigo(FilterSet,NewKick),
        %vericar se jï¿½ foi realizado o chute.
       % if(orderAlreadyKicked(NewKick),newKick(FilterSet, NewKick),addOrderAlreadyKicked(NewKick));
        ListDigitsOut = listOutSolutionDigits,
        mastermind(NewKick,ListDigitsOut,_).% gerar codigo


adiciona_aleatorio(Lin, Sf, Lout) :-
            random_between(1, 6, N),
            not(member(N, Sf)),
            append([N], Lin, Lout), !;
            adiciona_aleatorio(Lin, Sf, Lout).

        % gera_codigo(-ConjuntoFiltros, +ListaSaida)
        gera_codigo(Sf, Lout) :-
            gera_codigo(4, [], Sf, Lout).

        % gera_codigo(-QuantidadeDeNumeros, -ListaEntrada, _, -ListaSaida)
        gera_codigo(Cnt, L, _, L) :-
            length(L, Cnt), !.

        % gera_codigo(-QuantidadeDeNumeros, -ListaEntrada, -ConjuntoFiltros, +ListaSaida)
        gera_codigo(Cnt, Lin, Sf, Lout) :-
            length(Lin, Tin), Tin < Cnt, !,
            adiciona_aleatorio(Lin, Sf, Lmid),
            gera_codigo(Cnt, Lmid, Sf, Lout).

