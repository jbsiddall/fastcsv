:- module(fastcsv, [dict_reader/3]).

dict_reader(FileName, Records, Options) :-
  read_records(FileName, Records).

read_records(FileName, Records) :-
  open(FileName, read, Handle), !,
  read_header(Handle, Header), !,
  read_records_helper(Handle, Header, Records, []), !,
  close(Handle).

read_header(Handle, Header) :-
  my_read_line(Handle, Line), !,
  split_string(Line, ",", " ", List), !,
  maplist(atom_string, Header, List).

read_records_helper(Handle, Header, Records, WorkingRecords) :-
  my_read_line(Handle, Line), !,
  line_to_record(Line, Header, Record), !,
  read_records_helper(Handle, Header, Records, [Record|WorkingRecords]).

read_records_helper(_, _, Records, Records).

my_read_line(Handle, Line) :-
  read_string(Handle, "\n", "\r", Sep, Line), !,
  Sep \= -1.

line_to_record(Line, Header, Record) :-
  split_string(Line, ",", " ", Values), !,
  parse_row_into_record(Header, Values, Record).

parse_row_into_record(Header, Values, Record) :-
  parse_row_into_record(Header, Values, Record, row{}).

parse_row_into_record([], [], Record, Record).
parse_row_into_record([Key|Header], [Value|Values], Record, WorkingRecord) :-
  parse_row_into_record(Header, Values, Record, WorkingRecord.put(Key, Value)).
