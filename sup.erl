-module(sup).

-behaviour(gen_server).
-export([init/1,handle_call/3,handle_cast/2]).
-export([terminate/2]).
-export([quit/1,start/0,stop/1,handle_info/2]).

start()->
    gen_server:start_link(?MODULE,?MODULE,[]).
stop(Ref)->
    gen_server:stop(Ref).
quit(Pid)->
    gen_server:call(Pid,q).

init(Data)->
    file:delete("D:/Erlang/Supervisor/err.txt"),
    {ok,initt,100000}.

handle_info(Reason,State)->
    Do= case Reason of 
           cast  -> noreply; 
           _ -> stop 
          end,
    {Do,Reason,State}.
handle_call(Request,From,State)->
    Return={reply,State,call,4000},
    Return.
handle_cast(MSG,State)->
    {noreply,cast,3000}.

terminate(Reason,State)->
    {ok,S}=file:open("D:/Erlang/Supervisor/err.txt",[read,write,append]),
    io:format(S,"~s~n",[State]),
    ok.
    