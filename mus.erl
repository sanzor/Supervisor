-module(mus).
-export([init/1,terminate/2]).
-export([handle_call/3,handle_cast/2,handle_info/2]).
-behaviour(gen_server).
-define(DELAY,750).
-record(state,{
    name,
    skill
}).


handle_call(Message,From,State)->
    {reply,Message,State}.

handle_cast(Message,State=#state{name=N,skill=good}}->
    {noreply,State,?DELAY}.
handle_info(Message,State=#state{name=N,skill=bad})->
    {stop,}