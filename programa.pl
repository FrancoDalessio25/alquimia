%Parcial ALquimia

% 1 - Base de conocimientos
tiene(ana, agua).
tiene(ana, vapor).
tiene(ana, tierra).
tiene(ana, hierro).
tiene(beto, Material):- 
    tiene(ana, Material).
tiene(cata, fuego).
tiene(cata, tierra).
tiene(cata, agua).
tiene(cata, aire).

construir(pasto, agua).
construir(pasto, tierra).
construir(hierro, fuego).
construir(hierro, agua).
construir(hierro, tierra).
construir(huesos, pasto).
construir(huesos, agua).
construir(presion, hierro).
construir(presion, vapor).
construir(vapor, fuego).
construir(vapor, agua).
construir(playStation, silicio).
construir(playStation, hierro).
construir(playStation, plastico).
construir(silicio, tierra).
construir(plastico, huesos).
construir(plastico, presion).

% circulo(diametro, nivel).
herramienta(ana, circulo(50,3)).
% cuchara(longitud).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

esJugador(Jugador):- 
    herramienta(Jugador, _).   % si tiene herramienta

esElemento(Elemento):- 
    tiene(_, Elemento).      % si alguien lo tiene

% 2
tieneIngredientesPara(Jugador, Elemento):-
    esJugador(Jugador),
    construir(Elemento, _),
    forall(construir(Elemento, Material), tiene(Jugador, Material)).

% 3
estaVivo(Elemento):-
    estaVivoOestaConstruidoPorElementosVivos(Elemento).

estaVivoOestaConstruidoPorElementosVivos(fuego).
estaVivoOestaConstruidoPorElementosVivos(agua).
estaVivoOestaConstruidoPorElementosVivos(Elemento):-
    findall(Material, construir(Elemento, Material), Materiales),
    member(fuego, Materiales),
    member(agua, Materiales).                                   
estaVivoOestaConstruidoPorElementosVivos(Elemento):-
    construir(Elemento, OtroElemento),
    esElemento(OtroElemento),
    Elemento \= OtroElemento,
    estaVivoOestaConstruidoPorElementosVivos(OtroElemento).

% 4
puedeConstruir(Persona, Elemento):-                         
    tieneIngredientesPara(Persona, Elemento),
    tieneHerramientaParaConstruirloEsaPersona(Persona, Elemento).        

tieneHerramientaParaConstruirloEsaPersona(Persona, Elemento):-      
    herramienta(Persona, Herramienta),                                 
    tieneHerramientaParaConstruirlo(Herramienta, Elemento).
    
tieneHerramientaParaConstruirlo(libro(vida), Elemento):-
     estaVivo(Elemento).

tieneHerramientaParaConstruirlo(libro(inerte), Elemento):-
     not(estaVivo(Elemento)).

tieneHerramientaParaConstruirlo(Herramienta, Elemento):-    
    cantidadDeIngredientes(Elemento, Cantidad),
    cantidadMaximaQsoporta(Herramienta, MaxElementosQueSoporta),
    MaxElementosQueSoporta >= Cantidad.

cantidadMaximaQsoporta(cuchara(Longitud), MaxElementosQueSoporta):-
    MaxElementosQueSoporta is Longitud/10.
cantidadMaximaQsoporta(circulo(Diametro, Niveles), MaxElementosQueSoporta):-
    Metros is Diametro/100,
    MaxElementosQueSoporta is Metros*Niveles.

cantidadDeIngredientes(Elemento, Cantidad):-
    findall(Ingrediente, construir(Elemento, Ingrediente), Ingredientes),
    length(Ingredientes, Cantidad).

% 5
esTodoPoderoso(Jugador):-
    esJugador(Jugador),
    forall(esElementoPrimitivo(Elemento), tiene(Jugador, Elemento)),
    puedeConstruirLosElementosQueNoTiene(Jugador).

esElementoPrimitivo(Elemento):-
    esElemento(Elemento),
    not(construir(Elemento, _)).                

puedeConstruirLosElementosQueNoTiene(Jugador):-
    herramienta(Jugador, Herramienta),
    forall(elementoQueNoTieneNiEsPrimitivo(Jugador, Elemento), tieneHerramientaParaConstruirlo(Herramienta, Elemento)).

elementoQueNoTieneNiEsPrimitivo(Jugador, Elemento):-
    not(tiene(Jugador, Elemento)),
    not(esElementoPrimitivo(Elemento)).

% 6
gana(Jugador):-
    esJugador(Jugador),
    cantidadDeCosasQuePuedeConstruirUnJugador(Jugador, Cantidad),
    esJugador(OtroJugador),
    Jugador \= OtroJugador,
    forall(cantidadDeCosasQuePuedeConstruirUnJugador(OtroJugador, OtraCantidad), Cantidad > OtraCantidad).

cantidadDeCosasQuePuedeConstruirUnJugador(Jugador, Cantidad):-
    findall(ElementoAConstruir, distinct(ElementoAConstruir, puedeConstruir(Jugador, ElementoAConstruir)), Construcciones),
    length(Construcciones, Cantidad).
/*  Agrego esta segunda version que es la otra forma que se que se puede hacer que no de repetido, porque no se si distinct se podía usar:
cantidadDeCosasQuePuedeConstruirUnJugador(Jugador, Cantidad):-
    findall(ElementoAConstruir, puedeConstruir(Jugador, ElementoAConstruir), Construcciones),
    list_to_set(Construcciones, Cantidad),    
    length(Construcciones, Cantidad).
*/

% 7
/*  El uso de universo cerrado se usa por ejemplo en la representacion del hecho de que cata tiene fuego, tierra, agua y aire, pero NO tiene vapor.
    No hace falta hacer un predicado para determinar que cata no tiene vapor, ya que por el concepto de universo cerrado que se aplica en el paradigma
    lógico, todo lo que no este va a ser considerado falso, Prolog entran en esta categoría.
*/

% 8
% de todas formas no me da, no c porque, no c si estoy aplicando algo mal o si tiene que ver con algo que este dandome mal de los anteriores
puedeLlegarATener(Jugador, Elemento):- tiene(Jugador, Elemento).
puedeLlegarATener(Jugador, Elemento):-
    tieneHerramientaParaConstruirlo(Jugador, Elemento),
    not((construir(Elemento, Ingrediente), not(puedeLlegarATener(Jugador, Ingrediente)))).