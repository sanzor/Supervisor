-module(sup).

-behaviour(gen_server).
-export([init/1,handle_call/3,handle_cast/2]).
-compile(export_all).
-define(DELAY,750).
-define(TIME,3000).
-record(state,{
    name,
    qual,
    job
}).
start(Job,Qual)->
    {ok,X}=gen_server:start_link(?MODULE,?MODULE,[Job,Qual]),
    X.
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
init([Job,Qual])->
    process_flag(trap_exit,true),
    random:seed(now()),
    Jb=atom_to_list(Job),
    Name=pick_name(),
    {ok,#state{name=Name,qual=Qual,job=Jb},?DELAY}.

handle_info(timeout,State=#state{name=Name,qual=good})->
    io:format("~s produced good result ~n",[Name]),
    {noreply,State,?DELAY};
handle_info(timeout,State=#state{name=Name,qual=bad})->
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

terminate(normal,S)->
    io:format("~s:~s terminated normally ~n",[S#state.name,S#state.job]);
terminate(no_more_chances,S)->
    io:format("~s:~s terminated due to no more chances",[S#state.name,S#state.job]);
terminate(shutdown,S)->
    io:format("~s:~s closed due to shutdown",[S#state.name,S#state.job]);
terminate(Reason,S)->
    io:format("~s:~s Unknown reason for terminating").


super(one)->
    init({one_for_one,3,60}).
