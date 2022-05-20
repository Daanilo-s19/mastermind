% adiciona_aleatorio(-ListaEntrada, -ConjuntoFiltros, +LSaida)
% pega um número aleatório entre [1, 6] que não esteja no ConjuntoFiltros
adiciona_aleatorio(Lin, Sf, Lout) :- 
	random_between(1, 6, N),
    not(member(N, Sf)),
    append([N], Lin, Lout), !;
    adiciona_aleatorio(Lin, Sf, Lout).
   
% gera_codigo(-ConjuntoFiltros, +ListaSaida)
% gera um código com quatro números
gera_codigo(Sf, Lout) :-
    gera_codigo(4, [], Sf, Lout).

% gera_codigo(-QuantidadeDeNumeros, -ListaEntrada, _, -ListaSaida)
% condição de parada se a lista de entrada for igual a lista de saída e tiver QuantidadeDeNumeros de cardinalidade
gera_codigo(Cnt, L, _, L) :-
    length(L, Cnt), !.

% gera_codigo(-QuantidadeDeNumeros, -ListaEntrada, -ConjuntoFiltros, +ListaSaida)
% adiciona os números gerados ao lista de saída até QuantidadeDeNumeros
gera_codigo(Cnt, Lin, Sf, Lout) :-
    length(Lin, Tin), Tin < Cnt, !,
    adiciona_aleatorio(Lin, Sf, Lmid),
    gera_codigo(Cnt, Lmid, Sf, Lout).