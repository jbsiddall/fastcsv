:- use_module(fastcsv, []).
:- initialization(main).

main :-
  fastcsv:dict_reader("data.csv", Rows, [strip(true)]),
  findall(Row, (member(Row, Rows), filter(Row)), Results),
  length(Results, ResultsSize),
  length(Rows, TotalSize),
  format("There are ~w results out of total ~w\n", [ResultsSize, TotalSize]),
  halt.

filter(Record) :-
  Record.'Name' = "Joseph", !,
  number_codes(Age, Record.'Age'), !,
  Age < 40.
