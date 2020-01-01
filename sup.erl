-module(sup).

-behaviour(gen_server).
-export([init/1,handle_call/3,handle_cast/2]).
-export([terminate/2]).
-export([cast/1,quit/1,start/0,stop/1,handle_info/2]).

start()->
    gen_server:start_link(?MODULE,?MODULE,[]).
stop(Ref)->
    gen_server:stop(Ref).
quit(Pid)->
    gen_server:call(Pid,q).

cast(Pid)->
    gen_server:cast(Pid,qq).
init(Data)->
    {ok,33}.

handle_info(Reason,State)->
    {stop,Reason,State}.
handle_call(Request,From,State)->
    Return={reply,State,State,5000},
    Return.

terminate(Reason,State)->
    io:format("got finished").
handle_cast(MSG,State)->
    {noreply,MSG}.
    