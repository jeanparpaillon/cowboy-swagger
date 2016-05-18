%%% @doc Cowboy Swagger Handler. This handler exposes a GET operation
%%%      to enable that  `swagger.json' can be retrieved from embedded
%%%      Swagger-UI (located in `priv/swagger' folder).
-module(cowboy_swagger_json_handler).

%% Cowboy callbacks
-export([ init/2
        , content_types_provided/2
        ]).

%% Handlers
-export([handle_get/2]).

-type state() :: #{}.
-type route_match() :: '_' | iodata().
-type options() :: #{server => ranch:ref(), host => route_match()}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Cowboy Callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% @hidden
-spec init(cowboy_req:req(), options()) ->
  {cowboy_rest, cowboy_req:req(), options()}.
init(Req, Opts) ->
  {cowboy_rest, Req, Opts}.

%% @hidden
-spec content_types_provided(cowboy_req:req(), state()) ->
  {[term()], cowboy_req:req(), state()}.
content_types_provided(Req, State) ->
  {[{<<"application/json">>, handle_get}], Req, State}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Handlers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% @hidden
handle_get(Req, State) ->
  Server = maps:get(server, State, '_'),
  HostMatch = maps:get(host, State, '_'),
  Trails = trails:all(Server, HostMatch),
  {cowboy_swagger:to_json(Trails), Req, State}.
