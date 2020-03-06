-module(solution).
-export([parse_fields_map/1, parse_fields_map_bin/1, put_map_data/4, parse_examples/0]).
-import(string, [substr/3]).


% unused list version parsing function, which can be another solution for problem #1.
parse_fields_list(Data) when is_list(Data) ->
    Datalen = string:len(Data), RepeatedId = (string:substr(Data, 65, 6) == string:substr(Data, 71, 6)),
    if (Datalen == 88) and RepeatedId -> [
        {account_number, substr(Data, 1, 16)}, 
        {code, substr(Data, 17, 6)}, 
        {amount, list_to_integer(substr(Data, 23, 12)) / 100}, 
        {datetime, substr(Data, 35, 2) ++ "/" ++ substr(Data, 37, 2) ++ "," 
        ++ substr(Data, 39, 2) ++ "h" ++ substr(Data, 41, 2) ++ "m" ++ substr(Data, 43, 2) ++ "s"}, 
        {trace_number, substr(Data, 45, 6)}, 
        {time, substr(Data, 51, 2) ++ "h" ++ substr(Data, 53, 2) ++ "m" ++ substr(Data, 55, 2) ++ "s"}, 
        {date, substr(Data, 57, 2) ++ "/" ++ substr(Data, 59, 2)},
        {capture_date, substr(Data, 61, 2) ++ "/" ++ substr(Data, 63, 2)}, 
        {company_id, substr(Data, 65, 6)}, 
        {reference_num, substr(Data, 77, 12)}]
    end.


% field parsing function for problem #1
% check parameter validity first then parse the data into certain fields in corresponding format. 
parse_fields_map(Data) when is_list(Data) ->
    Datalen = string:len(Data), RepeatedId = (string:substr(Data, 65, 6) == string:substr(Data, 71, 6)),
    if (Datalen == 88) and RepeatedId -> #{
        account_number => substr(Data, 1, 16), 
        code => substr(Data, 17, 6), 
        amount => list_to_integer(substr(Data, 23, 12)) / 100, 
        datetime => substr(Data, 35, 2) ++ "/" ++ substr(Data, 37, 2) ++ "," 
        ++ substr(Data, 39, 2) ++ "h" ++ substr(Data, 41, 2) ++ "m" ++ substr(Data, 43, 2) ++ "s", 
        trace_number => substr(Data, 45, 6), 
        time => substr(Data, 51, 2) ++ "h" ++ substr(Data, 53, 2) ++ "m" ++ substr(Data, 55, 2) ++ "s", 
        date => substr(Data, 57, 2) ++ "/" ++ substr(Data, 59, 2),
        capture_date => substr(Data, 61, 2) ++ "/" ++ substr(Data, 63, 2), 
        company_id => substr(Data, 65, 6), 
        reference_num => substr(Data, 77, 12)}
    end.


% convert binary data string to map
parse_fields_map_bin(Data) when is_binary(Data) ->
    parse_fields_map(binary_to_list(Data)).


% function that put target data to target database
% erlang jiffy library is required in this function.
% Username, Password, DBname are user defined strings for target database
% Data should be the MAP data parsed by 'parse_fields_map'
% use ref_{reference_num} as id for each document of transaction data.
put_map_data(Username, Password, DBname, Data) when is_map(Data), is_list(Username), is_list(Password), is_list(DBname) ->
    inets:start(),
    DocId = "ref_" ++ element(2, maps:find(reference_num, Data)), 
    httpc:request(put, {
        "http://" ++ Username ++ ":" ++ Password ++ "@localhost:5984/" ++ DBname ++ "/" ++ DocId, 
        [], "application/json", 
        jiffy:encode(maps:map(fun(K, V) -> if is_list(V) -> list_to_binary(V); true -> V end end, Data))}, [], []).


% run and show the result of parsing example data with 'parse_fields_map' 
parse_examples() ->
    Data_1 = <<"0000011319353459011000000000020000080403001305102808301308040804123456123456192165102801">>, 
    Data_2 = <<"0000011519355459011000000000041000080403001305102808301308040804123456123456192165102839">>, 
    io:format("result for first string:\n"), 
    erlang:display(parse_fields_map_bin(Data_1)), 
    io:format("result for second string:\n"), 
    erlang:display(parse_fields_map_bin(Data_2)), 
    ok.