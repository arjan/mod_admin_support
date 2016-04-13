%% @author Arjan Scherpenisse <arjan@miraclethings.nl>
%% @copyright 2016 Arjan Scherpenisse
%% @doc Support routines for quickly building admin interfaces and JSON APIs

%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%% 
%%     http://www.apache.org/licenses/LICENSE-2.0
%% 
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(mod_admin_support).
-author("Arjan Scherpenisse").

-mod_title("Admin support routines").
-mod_description("Support routines for quickly building admin interfaces and JSON APIs.").
-mod_prio(500).

-include_lib("zotonic.hrl").

-export([event/2]).

%%====================================================================
%% support functions go here
%%====================================================================

event(#submit{message={edit_config_save, [{module, Module}, {fields, Fields}]}}, Context) ->
    [ok = save_field(Module, Field, Context) || {Field, _Label} <- Fields],
    z_render:growl("Saved", Context).

save_field(Module, Field, Context) ->
    Value = z_context:get_q(z_convert:to_list(Field), Context),
    m_config:set_value(Module, Field, Value, Context).
