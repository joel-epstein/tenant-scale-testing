package v3

import (
	v3 "envoyproxy.io/type/http/v3"
)

// This extension allows the session state to be tracked via cookies.
//
// This extension first encodes the address of the upstream host selected by the load balancer
// into a `set-cookie` response header with the :ref:`cookie configuration
// <envoy_v3_api_field_extensions.http.stateful_session.cookie.v3.CookieBasedSessionState.cookie>`.
// when new requests are incoming, this extension will try to parse the specific upstream host
// address by the cookie name. If the address parsed from the cookie corresponds to a valid
// upstream host, this upstream host will be selected first. See :ref:`stateful session filter
// <envoy_v3_api_msg_extensions.filters.http.stateful_session.v3.StatefulSession>`.
//
// For example, if the cookie name is set to `sticky-host`, envoy will prefer `1.2.3.4:80`
// as the upstream host when the request contains the following header:
//
// .. code-block:: none
//
//     cookie: sticky-host="MS4yLjMuNDo4MA=="
//
// When processing the upstream response, if `1.2.3.4:80` is indeed the final choice the extension
// does nothing. If `1.2.3.4:80` is not the final choice, the new selected host will be used to
// update the cookie (via the `set-cookie` response header).
//
// [#extension: envoy.http.stateful_session.cookie]
#CookieBasedSessionState: {
	// The cookie configuration used to track session state.
	cookie?: v3.#Cookie
}
