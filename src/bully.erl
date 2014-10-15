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

-define(ELECTION_MESSAGE, election).
-define(ELECTION_MESSAGE_RESPONSE, ok).
-define(COORDINATOR_MESSAGE, imtheboss).
-define(RESPONSE_TIMEOUT, 20).

-record(state, {timeout = infinity, knownnodes = [], coordinator = node()}).

start(Nodes) ->
  register(?MODULE, self()),
  io:format("Node ~s has a PId of ~s.~n", [node(), os:getpid()]).
%%   loop(greetNodes(#state{knownnodes = Nodes})).

loop(State) ->
  Timeout = State#state.timeout,
  NewState = receive
               {?ELECTION_MESSAGE, Node} -> handleElectionMessage(State, Node);
               {?ELECTION_MESSAGE_RESPONSE, Node} -> waitForCoordinatorMessage(State);
               {?COORDINATOR_MESSAGE, Node} -> setCoordinator(State, Node)
             after
               Timeout -> becomeCoordinator(State)
             end,
  io:format("~s reached loop end~n", [node()]),
  loop(NewState).

handleElectionMessage(State, Node) ->
  State.

waitForCoordinatorMessage(State) ->
  NewState = State#state{timeout = ?RESPONSE_TIMEOUT},
  NewState.

setCoordinator(State, Node) ->
  State.

log(State, Node) ->
  io:format("~s received something from node ~s~n", [node(), atom_to_list(Node)]),
  State.

addKnownNode(State, Node) ->
  io:format("Node ~s received a message from previously unknown node ~s~n,", [node(), atom_to_list(Node)]),
  NewState = #state{knownnodes = lists:append([State#state.knownnodes,[Node]])},
  NewState.


sendMessageToNode(Node, Message) ->
  io:format("Node ~s is sending message ~s to node ~s~n", [node(), Message, atom_to_list(Node)]),
  {?MODULE, Node} ! {Message, node()}.

