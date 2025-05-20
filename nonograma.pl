% ->Título: Nonograma.pl (resolvedor de nonogramas)
% ->Autores: Marcos Socías Alberto y Hugo Valls Sabater
% ->Fecha última modificación: 19/05/2025
% ->Asignatura: Lenguajes de Programación
% ->Grupo: 102
% ->Profesor teoría: Antoni Oliver Tomàs
% ->Profesor prácticas: Francesc Xavier Gaya Morey
% ->Convocatoria: Ordinaria
% ->Indicaciones uso predicados: Para resolver un nonograma, hay que
% seguir la siguiente estructura: nonograma([[],[]], [[],[]], Caselles)
% que representa una lista de listas, y el
% resultado se almacenará en Caselles. Por ejemplo:
% nonograma([[5], [], [2, 1], [1], [1, 2]],[[1, 1], [1, 1], [1, 1, 1], [1, 2], [1, 1]],Caselles).
% ->Extras implementados: Nonogramas rectangulares: se calcula
% la longitud de cada fila a partir del número de columnas
% y se transpone la matriz generada para validar las pistas de
% las columnas sin asumir una estructura cuadrada.
% ->Explicación del diseño: El programa se basa en construir una matriz de casillas a partir de las
% pistas de filas y columnas. Primero, con generar_filas, se crean las filas respetando las pistas
% dadas, usando fila_valida para comprobar que cada fila sea válida. Luego se utiliza transposar
% para convertir filas en columnas y así poder validar las columnas con validar_columnas.
% Gracias a que se calcula el número de columnas con length, la solución funciona también para nonogramas
% rectangulares. En lugar de generar todas las posibles soluciones, el programa va comprobando directamente
% si una combinación de unos y ceros cumple con las pistas.


% nonograma(Filas, Columnas, Casillas)
% Resuelve el nonograma definido por las pistas de las filas y las columnas.
% Filas: lista de pistas para cada fila (cada pista es una lista de bloques).
% Columnas: lista de pistas para cada columna.
% Casillas: matriz de salida que representa el nonograma resuelto (relleno = 1, vacío = 0).
nonograma(Filas, Columnas, Casillas) :-
    length(Columnas, Ancho),
    generar_filas(Filas, Ancho, Casillas),
    transposada(Casillas, Transpuesta),
    validar_columnas(Columnas, Transpuesta).

% generar_filas(Filas, Longitud, Casillas)
% Genera una lista de filas válidas que cumplan las pistas dadas y tengan la longitud indicada.
% Filas: lista de pistas para cada fila.
% Longitud: número de columnas que debe tener cada fila.
% Casillas: lista resultante de filas válidas (matriz parcial del nonograma).
generar_filas([], _, []).
generar_filas([Pista|Resto], Longitud, [Fila|Filas]) :-
    length(Fila, Longitud),
    fila_valida(Pista, Fila),
    generar_filas(Resto, Longitud, Filas).

% fila_valida(Pista, Fila)
% Verifica que una fila cumpla con su pista.
% Pista: lista de números que indica los bloques consecutivos de 1's requeridos.
% Fila: lista de 0's y 1's que representa una posible fila del nonograma.
fila_valida(Pista, Fila) :-
    fila_valida_aux(Pista, Fila, Resto),
    solo_ceros(Resto).

% fila_valida_aux(Pista, Fila, Resto)
% Procesa la fila aplicando los bloques indicados en la pista.
% Pista: bloques a ubicar.
% Fila: parte actual de la fila.
% Resto: lo que queda de la fila tras ubicar los bloques.
fila_valida_aux([], Fila, Fila).
fila_valida_aux([X], Fila, Resto) :-
    saltar_ceros(Fila, F1),
    poner_unos(X, F1, Resto).
fila_valida_aux([X|Xs], Fila, Resto) :-
    Xs \= [],
    saltar_ceros(Fila, F1),
    poner_unos(X, F1, [0|F2]),
    fila_valida_aux(Xs, F2, Resto).

% saltar_ceros(Fila, Resto)
% Omite los ceros al principio de la fila.
% Fila: fila original.
% Resto: parte de la fila que empieza tras los ceros iniciales.
saltar_ceros([0|T], R) :- saltar_ceros(T, R).
saltar_ceros(R, R).

% poner_unos(N, Fila, Resto)
% Coloca N unos consecutivos al principio de la fila.
% N: cantidad de 1's que deben colocarse.
% Fila: parte de la fila donde se colocarán los 1's.
% Resto: parte restante de la fila después de colocar los 1's.
poner_unos(0, R, R).
poner_unos(N, [1|T], R) :-
    N > 0,
    N1 is N - 1,
    poner_unos(N1, T, R).

% solo_ceros(Lista)
% Comprueba que la lista está formada solo por ceros.
% Lista: secuencia de casillas (esperada como todo 0's al final de una fila válida).
solo_ceros([]).
solo_ceros([0|T]) :- solo_ceros(T).

% transposada(Matriz, Transpuesta)
% Calcula la transpuesta de una matriz (intercambia filas por columnas).
% Matriz: matriz original representada como lista de listas (filas).
% Transpuesta: matriz resultante con filas y columnas intercambiadas.
transposada(M, []) :- M = [PF | _], PF = [], !.
transposada(M, [PC|TRC]) :-
    obte1acol(M, PC),
    obterestacols(M, RC),
    transposada(RC, TRC).

% obte1acol(Matriz, Columna)
% Extrae la primera columna de una matriz.
% Matriz: lista de listas donde cada sublista representa una fila.
% Columna: lista formada por el primer elemento de cada fila.
obte1acol([], []).
obte1acol([PF|RF], [PC|RPC]) :-
    PF = [PC| _],
    obte1acol(RF, RPC).

% obterestacols(Matriz, Restante)
% Extrae las subfilas sin el primer elemento de cada fila de una matriz.
% Matriz: lista de listas donde cada sublista representa una fila.
% Restante: matriz con las filas originales sin su primer elemento.
obterestacols([], []).
obterestacols([PF|RF], [RPF|RPC]) :-
    PF = [_|RPF],
    obterestacols(RF, RPC).

% validar_columnas(Columnas, Transpuesta)
% Verifica que cada columna transpuesta cumpla con su pista correspondiente.
% Columnas: lista de pistas para las columnas.
% Transpuesta: matriz transpuesta, que permite tratar columnas como filas.
validar_columnas([], []).
validar_columnas([Pista|Pistas], [Columna|Columnas]) :-
    fila_valida(Pista, Columna),
    validar_columnas(Pistas, Columnas).
