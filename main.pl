:- set_prolog_stack(global, limit(100 000 000 000)).
:- set_prolog_stack(local, limit(100 000 000 000)).
:- use_module('./fastcsv.pl').
:- initialization(main).

main :-
  profile(fastcsv_read_file("data.csv", Rows, [strip(true)])),
  findall(Row, (member(Row, Rows), filter(Row)), Results),
  length(Results, ResultsSize),
  length(Rows, TotalSize),
  format("There are ~w results out of total ~w\n", [ResultsSize, TotalSize]),
  halt.

filter(Record) :-
  Record.'Name' = "Joseph",
  number_codes(Age, Record.'Age'),
  Age < 40.
