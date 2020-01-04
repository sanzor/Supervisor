-module(sup).

-behaviour(gen_server).
-export([init/1,handle_call/3,handle_cast/2]).
-compile(export_all).
-define(DELAY,750).
-define(TIME,3000).
-record(state,{
    name,
    qual,
    pos
}).
start(Role,Pos)->
    gen_server:start_link(?MODULE,?MODULE,[Role,Pos]).
stop(Ref)->
    gen_server:stop(Ref).
quit(Pid)->
    gen_server:call(Pid,q).

names()->
    ["Adrian","Dan","Simon","Eckbert","Ramon","Hassan"].
surnames()->
    ["Itzaak","Popescu","Davidson","Pop","Nasrallah"].

pick_name()->
    lists:nth(random:unfirom(6),names)++" "++lists:nth(random:unfirom(5),surnames).
init([Qual,Pos])->
    process_flag(trap_exit,true),
    random:seed(now()),
    Position=atom_to_list(Pos),
    Name=pick_name(),
    {ok,#state{name=Name,qual=Qual},?DELAY}.

handle_info(timeout,State=#state{name=Name,qual=good})->
    io:format("~s produced good result ~n",[Name]),
    {noreply,State,?DELAY};
handle_info(timeout,State=#state{qual=bad,name=Name})->
    case random:uniform(3) of
        1 -> io:format(" ~s got one more chance~n",[Name]),
             {noreply,State,?DELAY};
        _ -> io:format(" ~s no more chances, terminating ~n!",[Name]),
             {stop,no_more_chances,State}
    end;
handle_info(MSG,State)->
    {noreply,State,?TIME}.

handle_call(Request,From,State)->
    Return={reply,State,call,?DELAY},
    Return.
handle_cast({run,Name,Qual},State)->
    {noreply,#state{name=Name,qual=Qual},?DELAY};
handle_cast(_,State)->
    {noreply,State}.
terminate(Reason,State)->
    {ok,S}=file:open("D:/Erlang/Supervisor/err.txt",[read,write,append]),
    io:format(S,"~s~n",[State]),
    ok.
    