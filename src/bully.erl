%%%-------------------------------------------------------------------
%%% @author vovak
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Oct 2014 13:07
%%%-------------------------------------------------------------------
-module(bully).
-author("vovak").

%% API
-export([start/1]).


-record(state, {knownnodes = []}).


start(Nodes) ->
  register(?MODULE, self()),
  io:format("Node ~s has a PId of ~s.~n", [node(), os:getpid()]),
  loop(greetNodes(#state{knownnodes = Nodes})).

loop(State) ->
  NewState = receive
               {_Msg, Node} ->
                 addKnownNode(State,Node)
             after
               infinity -> State
             end,
  io:format("~s reached loop end~n", [node()]),
  loop(NewState).

log(State, Node) ->
  io:format("~s received something from node ~s~n", [node(), atom_to_list(Node)]),
  State.

addKnownNode(State, Node) ->
  io:format("Node ~s received a message from previously unknown node ~s~n,", [node(), atom_to_list(Node)]),
  NewState = #state{knownnodes = lists:append([State#state.knownnodes,[Node]])},
  NewState.

greetNodes(#state{knownnodes = Nodes} = State) ->
  lists:foreach(fun sendMessageToNode/1, Nodes),
  State#state{knownnodes = Nodes}.

sendMessageToNode(Node) ->
  io:format("Node ~s is attempting to send message to node ~s~n", [node(), atom_to_list(Node)]),
  {?MODULE, Node} ! {hithere, node()}.

