-module(mus).
-compile(export_all).
-behaviour(gen_server).
-define(DELAY,750).
-record(state,{
    name,
    skill,
    role
}).

start_link(Role, Skill) ->
gen_server:start_link({local, Role}, ?MODULE, [Role, Skill], []).
 
stop(Role) -> gen_server:call(Role, stop).

init([Role,Skill])->
    process_flag(trap_exit,true),
    random:seed(now()),
    TimeToPlay=random:uniform(3000),
    Name=pick_name(),
    StrRole=atom_to_list(Role),
    io:format("Musician ~s, playing  the ~s entered the room ~n",[Name,StrRole]),
    {ok,#state{name=Name,role=StrRole,skill=Skill},TimeToPlay}.

handle_call(Message,From,State)->
    {stop,normal,ok,State};
handle_call(_,_,S)->
    {noreply,S,?DELAY}.

handle_cast(Message,State)->
    {noreply,State,?DELAY}.
handle_info(Message,State=#state{name=N,skill=good})->
    io:format("~s produced good sound~n",[N]),
    {noreply,State,?DELAY};
handle_info(Message,State=#state{name=N,skill=bad})->
    case random:uniform(5) of
        1->
            io:format("~s played a false note~n",[N]),
            {stop,bad_note,State};
        _ ->
            io:format("~s produced good sound~n",[N]),
            {noreply,State,?DELAY}
   end;
handle_info(Message,State)->
    {noreply,State,?DELAY}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
    
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


terminate(normal,S)->
    io:format("~s left the room (~s)~n",[S#state.name,S#state.role]);
terminate(bad_note,S)->
    io:format("~s sucks,kicked out of the band (~s)~n",[S#state.name,S#state.role]);
terminate(shutdown,S)->
    io:format("The manager is bad and fired all band~n");
terminate(_Reason,S)->
    io:format("~s has been kicked out~n",[S#state.name]).
