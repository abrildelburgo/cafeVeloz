%CAFE VELOZ

% jugadores conocidos
jugador(maradona).
jugador(chamot).
jugador(balbo).
jugador(caniggia).
jugador(passarella).
jugador(pedemonti).
jugador(basualdo).

% relaciona lo que toma cada jugador
tomo(maradona, sustancia(efedrina)).
tomo(maradona, compuesto(cafeVeloz)).
tomo(caniggia, producto(cocacola, 2)).
tomo(chamot, compuesto(cafeVeloz)).
tomo(balbo, producto(gatoreit, 2)).
tomo(pasarella,Tomado):-    %PUNTO1
	not(tomo(maradona,Tomado)).
tomo(pedemonti,Tomado):-
	tomo(chamot,Tomado).
tomo(pedemonti,Tomado):-
	tomo(maradona,Tomado).

% relaciona la máxima cantidad de un producto que 1 jugador puede ingerir
maximo(cocacola, 3). 
maximo(gatoreit, 1).
maximo(naranju, 5).

% relaciona las sustancias que tiene un compuesto
composicion(cafeVeloz, [efedrina, ajipupa, extasis, whisky, cafe]).

% sustancias prohibidas por la asociación
sustanciaProhibida(efedrina). 
sustanciaProhibida(cocaina). 

amigo(maradona, caniggia).
amigo(caniggia, balbo).
amigo(balbo, chamot).
amigo(balbo, pedemonti).

atiende(cahe, maradona).
atiende(cahe, chamot).
atiende(cahe, balbo).
atiende(zin, caniggia).
atiende(cureta, pedemonti).
atiende(cureta, basualdo). 

nivelFalopez(efedrina, 10).
nivelFalopez(cocaina, 100).
nivelFalopez(extasis, 120).
nivelFalopez(omeprazol, 5). 

%PUNTO2
puedeSerSuspendido(Jugador):-
	jugador(Jugador),
	tomo(Jugador,sustancia(Sustancia)),
	sustanciaProhibida(Sustancia).
puedeSerSuspendido(Jugador):-
	jugador(Jugador),
	tomo(Jugador,compuesto(Compuesto)),
	compuestoConSustanciaProhibida(Compuesto).
puedeSerSuspendido(Jugador):-
	jugador(Jugador),
	tomo(Jugador,producto(Producto,CantidadTomada)),
	maximo(Producto,MaximoPermitido),
	MaximoPermitido<CantidadTomada.

compuestoConSustanciaProhibida(Compuesto):-
	composicion(Compuesto,Sustancias),
	member(Sustancia,Sustancias),
	sustanciaProhibida(Sustancia).

%PUNTO3
malaInfluencia(Jugador1,Jugador2):-
	jugador(Jugador1),	
	jugador(Jugador2),
	puedeSerSuspendido(Jugador1),
	puedeSerSuspendido(Jugador2),
	seConocen(Jugador1,Jugador2),
	Jugador1\=Jugador2.

seConocen(Jugador1,Jugador2):-
	amigo(Jugador1,Jugador2).
seConocen(Jugador1,Jugador2):-
	amigo(Jugador1,Tercero),
	seConocen(Tercero,Jugador2).

%PUNTO4
chanta(Medico):-
	atiende(Medico,_),
	forall(atiende(Medico,Jugador),puedeSerSuspendido(Jugador)).

%PUNTO5
cuantaFalopaTiene(Jugador,Alteracion):-
	jugador(Jugador),
	findall(SubAlteracion,tomoJugador(Jugador,SubAlteracion),ListaAlteraciones),
	sumlist(ListaAlteraciones,Alteracion).

tomoJugador(Jugador,SubAlteracion):-
	tomo(Jugador,Tomado).
	tipoTomado(Tomado,SubAlteracion).

tipoTomado(producto(_,_),0).
tipoTomado(sustancia(Sustancia),SubAlteracion):-
	nivelFalopez(Sustancia,SubAlteracion).
tipoTomado(compuesto(Compuesto),SubAlteracion):-
	composicion(Compuesto,ListaSustancias),
	findall(ValorSustancias,valorSustancias(ListaSustancias,ValorSustancias),ListaValorSustancias).
	sumlist(ListaValorSustancias,SubAlteracion).

valorSustancias(ListaSustancias,ValorSustancia):-
	member(Sustancia,ListaSustancias),
	nivelFalopez(Sustancia,ValorSustancia)).

%PUNTO6
medicoConProblemas(Medico):-
	atiende(Medico,_),
	findall(Jugador,(atiende(Medico,Jugador),conflictivo(Jugador)),ListaAtendidosConflictivos),
	length(ListaAtendidosConflictivos,Valor),
	Valor>3.

conflictivo(Jugador):-
	puedeSerSuspendido(Jugador).
conflictivo(Jugador):-
	seConocen(Jugador,maradona).

%PUNTO7
programaTVFantinesco(Lista):-
	findall(Jugador,puedeSerSuspendido(Jugador),Lista).
