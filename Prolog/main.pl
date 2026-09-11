periodo(262, '2026-2').
periodo(271, '2027-1').
periodo(272, '2027-2').
periodo(281, '2028-1').
periodo(282, '2028-2').
periodo(291, '2029-1').
periodo(292, '2029-2').

es_divisor(N, D) :-
    Limite is N - 1,
    between(1, Limite, D),
    N mod D =:= 0.

suma_alicuota(N, Suma) :-
    findall(D, es_divisor(N, D), Divisores),
    sumar_lista(Divisores, Suma).

sumar_lista([], 0).
sumar_lista([H|T], Suma) :-
    sumar_lista(T, SumaResto),
    Suma is H + SumaResto.

evaluar_categoria(N, Suma, 'Administrative') :- N < Suma, !.
evaluar_categoria(N, Suma, 'Engineering')    :- N =:= Suma, !.
evaluar_categoria(N, Suma, 'Humanities')     :- N > Suma, !.

clasificar_nicomaco(N, Categoria) :-
    nonvar(N), !,
    suma_alicuota(N, Suma),
    evaluar_categoria(N, Suma, Categoria).

clasificar_nicomaco(N, Categoria) :-
    var(N),
    between(1, 99, N),
    suma_alicuota(N, Suma),
    evaluar_categoria(N, Suma, Categoria).


paridad(Codigo, 'even') :- Codigo mod 2 =:= 0, !.
paridad(Codigo, 'odd')  :- Codigo mod 2 =\= 0, !.

formatear_consecutivo(N, ConsecutivoStr) :-
    nonvar(N), !, atom_concat('num', N, ConsecutivoStr).
formatear_consecutivo(N, ConsecutivoStr) :-
    var(N), nonvar(ConsecutivoStr), !,
    atom_concat('num', NAtom, ConsecutivoStr),
    atom_number(NAtom, N).
formatear_consecutivo(N, ConsecutivoStr) :-
    var(N), var(ConsecutivoStr),
    between(1, 999, N),
    atom_concat('num', N, ConsecutivoStr).

es_codigo_valido(Codigo) :-
    integer(Codigo),
    Codigo >= 26200000, 
    Codigo =< 29299999,
    P is Codigo div 100000,
    periodo(P, _).

codigo_caracteristicas(Codigo, PeriodoStr, CategoriaStr, ConsecutivoStr, ParidadStr) :-
    nonvar(Codigo),
    (   es_codigo_valido(Codigo) ->
        P is Codigo div 100000,
        C is (Codigo div 1000) mod 100,
        N is Codigo mod 1000,
        periodo(P, PeriodoStr),
        clasificar_nicomaco(C, CategoriaStr),
        formatear_consecutivo(N, ConsecutivoStr),
        paridad(Codigo, ParidadStr)
    ;   
        format('Error: El codigo es invalido. Debe tener 8 digitos y un periodo entre 262 y 292.~n', []),
        fail
    ).

:- initialization(main).

main :-
    writeln('=== SISTEMA DE REGISTRO - PREDICADO LOGICO ==='),
    bucle_interactivo.

bucle_interactivo :-
    write('Ingrese el codigo de estudiante (o escriba "salir"): '),
    flush_output,
    read_line_to_string(user_input, Entrada),
    (   Entrada == "salir" ->
        writeln('Saliendo del programa...')
    ;   
        % Intenta convertir el string ingresado a un número entero
        (   atom_number(Entrada, CodigoNum) ->
            (   codigo_caracteristicas(CodigoNum, P, C, N, Par) ->
                format('Resultado: ~w ~w ~w ~w~n', [P, C, N, Par])
            ;   true
            )
        ;   writeln('Error: Debe ingresar un valor numerico valido.')
        ),
        writeln('------------------------------------------------'),
        bucle_interactivo
    ).
