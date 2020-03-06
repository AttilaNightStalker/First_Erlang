# First_Erlang
A simple erlang test project

All the code is in 'solution.erl' file. 

For Problem#1, the major solution function is 'parse_fields_map' which parses a Erlang string list to a MAP of each field's value. 'parse_fields_map_bin' receive a binary string as input then convert it to string list and use 'parse_fields_map' to parse the result.

For Problem#2, the major solution function is 'put_map_data' which encode the MAP data to a json and send to the target database.

'parse_examples' demostrate the result of parsing two example strings.


