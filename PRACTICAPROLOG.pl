% nonograma(+Filas, +Columnas, -Casillas)
% Resuelve el nonograma definido por las pistas de filas y columnas, generando la matriz de casillas.
nonograma(Filas, Columnas, Casillas) :-
    length(Columnas, Ancho),
    generar_filas(Filas, Ancho, Casillas),
    transponer_manual(Casillas, Transpuesta),
    validar_columnas(Columnas, Transpuesta).

% generar_filas(+Filas, +Longitud, -Casillas)
% Genera todas las filas que cumplan con sus respectivas pistas y tengan la longitud indicada.
generar_filas([], _, []).
generar_filas([Pista|Resto], Longitud, [Fila|Filas]) :-
    length(Fila, Longitud),
    fila_valida(Pista, Fila),
    generar_filas(Resto, Longitud, Filas).

% fila_valida(+Pista, +Fila)
% Verifica que una fila cumpla con su pista correspondiente.
fila_valida(Pista, Fila) :-
    fila_valida_aux(Pista, Fila, Resto),
    solo_ceros(Resto).


% Caso base: sin más bloques en la pista
fila_valida_aux([], Fila, Fila).

% Caso en que aún quedan bloques por procesar y es el último
fila_valida_aux([X], Fila, Resto) :-
    saltar_ceros(Fila, F1),
    poner_unos(X, F1, Resto).

% Caso en que aún quedan varios bloques por procesar
fila_valida_aux([X|Xs], Fila, Resto) :-
    Xs \= [],
    saltar_ceros(Fila, F1),
    poner_unos(X, F1, [0|F2]),
    fila_valida_aux(Xs, F2, Resto).


% saltar_ceros(+Fila, -Resto)
% Salta ceros al principio de la fila.
saltar_ceros([0|T], R) :- saltar_ceros(T, R).
saltar_ceros(R, R).

% poner_unos(+N, +Fila, -Resto)
% Coloca N unos consecutivos al principio de la fila.
poner_unos(0, R, R).
poner_unos(N, [1|T], R) :-
    N > 0,
    N1 is N - 1,
    poner_unos(N1, T, R).

% solo_ceros(+Lista)
% Verifica que una lista esté compuesta únicamente por ceros.
solo_ceros([]).
solo_ceros([0|T]) :- solo_ceros(T).

% transponer_manual(+Matriz, -Transpuesta)
% Transpone manualmente una matriz de listas.
transponer_manual([], []).
transponer_manual([[]|_], []).
transponer_manual(Matriz, [PrimeraCol|RestoCols]) :-
    extraer_columna(Matriz, PrimeraCol, RestoFilas),
    transponer_manual(RestoFilas, RestoCols).

% extraer_columna(+Matriz, -Columna, -RestoFilas)
% Extrae la primera columna de la matriz y devuelve las filas restantes sin esa columna.
extraer_columna([], [], []).
extraer_columna([[X|Xs]|Resto], [X|Columna], [Xs|Filas]) :-
    extraer_columna(Resto, Columna, Filas).

% validar_columnas(+Columnas, +Transpuesta)
% Verifica que cada columna cumpla con su pista correspondiente.
validar_columnas([], []).
validar_columnas([Pista|Pistas], [Columna|Columnas]) :-
    fila_valida(Pista, Columna),
    validar_columnas(Pistas, Columnas).
