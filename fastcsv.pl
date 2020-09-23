:- module(fastcsv, [fastcsv_read_file/3, zip/3]).


fastcsv_read_file(FileName, Records, Options) :-
  read_file_into_lines(FileName, Lines), !,
  maplist(parse_line_into_values, Lines, ParsedLines), !,
  [HeaderString|Rest] = ParsedLines, !,
  maplist(atom_string, Header, HeaderString), !,
  maplist(parse_row_into_record(Header), Rest, Records).

read_file_into_lines(FileName, Lines) :-
  open(FileName, read, Handle),
  read_file_into_lines_helper(Handle, Lines),
  close(Handle).

read_file_into_lines_helper(Handle, Rows) :-
  read_file_into_lines_helper(Handle, Rows, []).

read_file_into_lines_helper(Handle, Rows, WorkingRows) :-
  read_string(Handle, "\n", "\r", Sep, Line),
  ( (Sep = -1) ->
      reverse(WorkingRows, Rows) ;
      read_file_into_lines_helper(Handle, Rows, [Line|WorkingRows])
  ).

parse_line_into_values(Line, List) :-
  split_string(Line, ",", " ", List).

parse_row_into_record(Header, Values, Record) :-
  parse_row_into_record(Header, Values, Record, row{}).

parse_row_into_record([], [], Record, Record).
parse_row_into_record([Key|Header], [Value|Values], Record, WorkingRecord) :-
  NewWorkingRecord = WorkingRecord.put(Key, Value),
  parse_row_into_record(Header, Values, Record, NewWorkingRecord).
