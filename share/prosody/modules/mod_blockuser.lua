local st = require "util.stanza";
local nodeprep = require "util.encodings".stringprep.nodeprep;

local block_patterns = module:get_option_set("registration_reserved_accounts", {});

function is_blocked(username)
	for pattern in block_patterns do
		if username:match(pattern) then
			return true;
		end
	end
end

module:hook("stanza/iq/jabber:iq:register:query", function(event)
	local session, stanza = event.origin, event.stanza;

	if stanza.attr.type == "set" then
		local query = stanza.tags[1];
		local username = nodeprep(query:get_child_text("username"));
		if username and is_blocked(username) then
			session.send(st.error_reply(stanza, "modify", "policy-violation", "Username is blocked"));
			return true;
		end
	end
end, 10);

