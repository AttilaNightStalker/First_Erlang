# First_Erlang -- Nexos code challenge project

All the code is in 'solution.erl' file. 

For Problem#1, the major solution function is 'parse_fields_map' which parses a Erlang string list to a MAP of each field's value. 'parse_fields_map_bin' receive a binary string as input then convert it to string list and use 'parse_fields_map' to parse the result.

For Problem#2, the major solution function is 'put_map_data' which encode the MAP data to a json and send to the target database. I use reference number as the id of each data document because reference number is a unique value of each transaction.

'parse_examples' demostrate the result of parsing two example strings.

'json_result.png' in this repo is the screen shot of my local database's json files.

There are more detailed descriptions in the comment of code. 

