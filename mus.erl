-module(mus).
-export([init/1,terminate/2]).
-export([handle_call/3,handle_cast/2,handle_info/2]).
-behaviour(gen_server).
-define(DELAY,750).
-record(state,{
    name,
    skill,
    role
}).

init([Role,Skill])->
    process_flag(trap_exit,true),
    random:seed(now()),
    TimeToPlay=random:uniform(3000),
    Name=pick_name(),
    StrRole=atom_to_list(Role),
    io:format("Musician ~s, playing  the ~s entered the room ",[Name,StrRole]),
    {ok,#state{name=Name,role=StrRole,skill=Skill},TimeToPlay}.

handle_call(Message,From,State)->
    {stop,normal,ok,S}.
handle_call(_,_,S)->
    {noreply,S,?DELAY}.

handle_cast(Message,State}->
    {noreply,State,?DELAY}.
handle_info(Message,State=#state{name=N,skill=good})->
    io:format("~s produced good sound",[N]),
    {noreply,S,?DELAY};
handle_info(Message,State=#state{name=N,skill=bad})->
    case random:uniform(5) of
        1->
            io:format("~s played a false note",[N]),
            {stop,bad_note,S};
        _ ->
            io:format("~s produced good sound",[N]),
            {noreply,S,?DELAY}
   end;
handle_info(Message,State)->
    {noreply,S,?DELAY}.


pick_name() ->
    lists:nth(random:uniform(10), firstnames())
    ++ " " ++
    lists:nth(random:uniform(10), lastnames()).
         
firstnames() ->
    ["Valerie", "Arnold", "Carlos", "Dorothy", "Keesha",
    "Phoebe", "Ralphie", "Tim", "Wanda", "Janet"].
         
lastnames() ->
    ["Frizzle", "Perlstein", "Ramon", "Ann", "Franklin",
    "Terese", "Tennelli", "Jamal", "Li", "Perlstein"].