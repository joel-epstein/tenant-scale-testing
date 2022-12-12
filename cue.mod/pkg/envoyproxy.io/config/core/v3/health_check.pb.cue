package v3

import (
	_struct "envoyproxy.io/deps/golang/protobuf/ptypes/struct"
	any "envoyproxy.io/deps/golang/protobuf/ptypes/any"
	v3 "envoyproxy.io/type/v3"
	v31 "envoyproxy.io/type/matcher/v3"
)

// Endpoint health status.
#HealthStatus: "UNKNOWN" | "HEALTHY" | "UNHEALTHY" | "DRAINING" | "TIMEOUT" | "DEGRADED"

HealthStatus_UNKNOWN:   "UNKNOWN"
HealthStatus_HEALTHY:   "HEALTHY"
HealthStatus_UNHEALTHY: "UNHEALTHY"
HealthStatus_DRAINING:  "DRAINING"
HealthStatus_TIMEOUT:   "TIMEOUT"
HealthStatus_DEGRADED:  "DEGRADED"

#HealthStatusSet: {
	// An order-independent set of health status.
	statuses?: [...#HealthStatus]
}

// [#next-free-field: 25]
#HealthCheck: {
	// The time to wait for a health check response. If the timeout is reached the
	// health check attempt will be considered a failure.
	timeout?: string
	// The interval between health checks.
	interval?: string
	// An optional jitter amount in milliseconds. If specified, Envoy will start health
	// checking after for a random time in ms between 0 and initial_jitter. This only
	// applies to the first health check.
	initial_jitter?: string
	// An optional jitter amount in milliseconds. If specified, during every
	// interval Envoy will add interval_jitter to the wait time.
	interval_jitter?: string
	// An optional jitter amount as a percentage of interval_ms. If specified,
	// during every interval Envoy will add interval_ms *
	// interval_jitter_percent / 100 to the wait time.
	//
	// If interval_jitter_ms and interval_jitter_percent are both set, both of
	// them will be used to increase the wait time.
	interval_jitter_percent?: uint32
	// The number of unhealthy health checks required before a host is marked
	// unhealthy. Note that for *http* health checking if a host responds with a code not in
	// :ref:`expected_statuses <envoy_v3_api_field_config.core.v3.HealthCheck.HttpHealthCheck.expected_statuses>`
	// or :ref:`retriable_statuses <envoy_v3_api_field_config.core.v3.HealthCheck.HttpHealthCheck.retriable_statuses>`,
	// this threshold is ignored and the host is considered immediately unhealthy.
	unhealthy_threshold?: uint32
	// The number of healthy health checks required before a host is marked
	// healthy. Note that during startup, only a single successful health check is
	// required to mark a host healthy.
	healthy_threshold?: uint32
	// [#not-implemented-hide:] Non-serving port for health checking.
	alt_port?: uint32
	// Reuse health check connection between health checks. Default is true.
	reuse_connection?: bool
	// HTTP health check.
	http_health_check?: #HealthCheck_HttpHealthCheck
	// TCP health check.
	tcp_health_check?: #HealthCheck_TcpHealthCheck
	// gRPC health check.
	grpc_health_check?: #HealthCheck_GrpcHealthCheck
	// Custom health check.
	custom_health_check?: #HealthCheck_CustomHealthCheck
	// The "no traffic interval" is a special health check interval that is used when a cluster has
	// never had traffic routed to it. This lower interval allows cluster information to be kept up to
	// date, without sending a potentially large amount of active health checking traffic for no
	// reason. Once a cluster has been used for traffic routing, Envoy will shift back to using the
	// standard health check interval that is defined. Note that this interval takes precedence over
	// any other.
	//
	// The default value for "no traffic interval" is 60 seconds.
	no_traffic_interval?: string
	// The "no traffic healthy interval" is a special health check interval that
	// is used for hosts that are currently passing active health checking
	// (including new hosts) when the cluster has received no traffic.
	//
	// This is useful for when we want to send frequent health checks with
	// `no_traffic_interval` but then revert to lower frequency `no_traffic_healthy_interval` once
	// a host in the cluster is marked as healthy.
	//
	// Once a cluster has been used for traffic routing, Envoy will shift back to using the
	// standard health check interval that is defined.
	//
	// If no_traffic_healthy_interval is not set, it will default to the
	// no traffic interval and send that interval regardless of health state.
	no_traffic_healthy_interval?: string
	// The "unhealthy interval" is a health check interval that is used for hosts that are marked as
	// unhealthy. As soon as the host is marked as healthy, Envoy will shift back to using the
	// standard health check interval that is defined.
	//
	// The default value for "unhealthy interval" is the same as "interval".
	unhealthy_interval?: string
	// The "unhealthy edge interval" is a special health check interval that is used for the first
	// health check right after a host is marked as unhealthy. For subsequent health checks
	// Envoy will shift back to using either "unhealthy interval" if present or the standard health
	// check interval that is defined.
	//
	// The default value for "unhealthy edge interval" is the same as "unhealthy interval".
	unhealthy_edge_interval?: string
	// The "healthy edge interval" is a special health check interval that is used for the first
	// health check right after a host is marked as healthy. For subsequent health checks
	// Envoy will shift back to using the standard health check interval that is defined.
	//
	// The default value for "healthy edge interval" is the same as the default interval.
	healthy_edge_interval?: string
	// Specifies the path to the :ref:`health check event log <arch_overview_health_check_logging>`.
	// If empty, no event log will be written.
	event_log_path?: string
	// [#not-implemented-hide:]
	// The gRPC service for the health check event service.
	// If empty, health check events won't be sent to a remote endpoint.
	event_service?: #EventServiceConfig
	// If set to true, health check failure events will always be logged. If set to false, only the
	// initial health check failure event will be logged.
	// The default value is false.
	always_log_health_check_failures?: bool
	// This allows overriding the cluster TLS settings, just for health check connections.
	tls_options?: #HealthCheck_TlsOptions
	// Optional key/value pairs that will be used to match a transport socket from those specified in the cluster's
	// :ref:`tranport socket matches <envoy_v3_api_field_config.cluster.v3.Cluster.transport_socket_matches>`.
	// For example, the following match criteria
	//
	// .. code-block:: yaml
	//
	//  transport_socket_match_criteria:
	//    useMTLS: true
	//
	// Will match the following :ref:`cluster socket match <envoy_v3_api_msg_config.cluster.v3.Cluster.TransportSocketMatch>`
	//
	// .. code-block:: yaml
	//
	//  transport_socket_matches:
	//  - name: "useMTLS"
	//    match:
	//      useMTLS: true
	//    transport_socket:
	//      name: envoy.transport_sockets.tls
	//      config: { ... } # tls socket configuration
	//
	// If this field is set, then for health checks it will supersede an entry of *envoy.transport_socket* in the
	// :ref:`LbEndpoint.Metadata <envoy_v3_api_field_config.endpoint.v3.LbEndpoint.metadata>`.
	// This allows using different transport socket capabilities for health checking versus proxying to the
	// endpoint.
	//
	// If the key/values pairs specified do not match any
	// :ref:`transport socket matches <envoy_v3_api_field_config.cluster.v3.Cluster.transport_socket_matches>`,
	// the cluster's :ref:`transport socket <envoy_v3_api_field_config.cluster.v3.Cluster.transport_socket>`
	// will be used for health check socket configuration.
	transport_socket_match_criteria?: _struct.#Struct
}

// Describes the encoding of the payload bytes in the payload.
#HealthCheck_Payload: {
	// Hex encoded payload. E.g., "000000FF".
	text?: string
	// [#not-implemented-hide:] Binary payload.
	binary?: bytes
}

// [#next-free-field: 13]
#HealthCheck_HttpHealthCheck: {
	// The value of the host header in the HTTP health check request. If
	// left empty (default value), the name of the cluster this health check is associated
	// with will be used. The host header can be customized for a specific endpoint by setting the
	// :ref:`hostname <envoy_v3_api_field_config.endpoint.v3.Endpoint.HealthCheckConfig.hostname>` field.
	host?: string
	// Specifies the HTTP path that will be requested during health checking. For example
	// */healthcheck*.
	path?: string
	// [#not-implemented-hide:] HTTP specific payload.
	send?: #HealthCheck_Payload
	// [#not-implemented-hide:] HTTP specific response.
	receive?: #HealthCheck_Payload
	// Specifies a list of HTTP headers that should be added to each request that is sent to the
	// health checked cluster. For more information, including details on header value syntax, see
	// the documentation on :ref:`custom request headers
	// <config_http_conn_man_headers_custom_request_headers>`.
	request_headers_to_add?: [...#HeaderValueOption]
	// Specifies a list of HTTP headers that should be removed from each request that is sent to the
	// health checked cluster.
	request_headers_to_remove?: [...string]
	// Specifies a list of HTTP response statuses considered healthy. If provided, replaces default
	// 200-only policy - 200 must be included explicitly as needed. Ranges follow half-open
	// semantics of :ref:`Int64Range <envoy_v3_api_msg_type.v3.Int64Range>`. The start and end of each
	// range are required. Only statuses in the range [100, 600) are allowed.
	expected_statuses?: [...v3.#Int64Range]
	// Specifies a list of HTTP response statuses considered retriable. If provided, responses in this range
	// will count towards the configured :ref:`unhealthy_threshold <envoy_v3_api_field_config.core.v3.HealthCheck.unhealthy_threshold>`,
	// but will not result in the host being considered immediately unhealthy. Ranges follow half-open semantics of
	// :ref:`Int64Range <envoy_v3_api_msg_type.v3.Int64Range>`. The start and end of each range are required.
	// Only statuses in the range [100, 600) are allowed. The :ref:`expected_statuses <envoy_v3_api_field_config.core.v3.HealthCheck.HttpHealthCheck.expected_statuses>`
	// field takes precedence for any range overlaps with this field i.e. if status code 200 is both retriable and expected, a 200 response will
	// be considered a successful health check. By default all responses not in
	// :ref:`expected_statuses <envoy_v3_api_field_config.core.v3.HealthCheck.HttpHealthCheck.expected_statuses>` will result in
	// the host being considered immediately unhealthy i.e. if status code 200 is expected and there are no configured retriable statuses, any
	// non-200 response will result in the host being marked unhealthy.
	retriable_statuses?: [...v3.#Int64Range]
	// Use specified application protocol for health checks.
	codec_client_type?: v3.#CodecClientType
	// An optional service name parameter which is used to validate the identity of
	// the health checked cluster using a :ref:`StringMatcher
	// <envoy_v3_api_msg_type.matcher.v3.StringMatcher>`. See the :ref:`architecture overview
	// <arch_overview_health_checking_identity>` for more information.
	service_name_matcher?: v31.#StringMatcher
}

#HealthCheck_TcpHealthCheck: {
	// Empty payloads imply a connect-only health check.
	send?: #HealthCheck_Payload
	// When checking the response, “fuzzy” matching is performed such that each
	// binary block must be found, and in the order specified, but not
	// necessarily contiguous.
	receive?: [...#HealthCheck_Payload]
}

#HealthCheck_RedisHealthCheck: {
	// If set, optionally perform ``EXISTS <key>`` instead of ``PING``. A return value
	// from Redis of 0 (does not exist) is considered a passing healthcheck. A return value other
	// than 0 is considered a failure. This allows the user to mark a Redis instance for maintenance
	// by setting the specified key to any value and waiting for traffic to drain.
	key?: string
}

// `grpc.health.v1.Health
// <https://github.com/grpc/grpc/blob/master/src/proto/grpc/health/v1/health.proto>`_-based
// healthcheck. See `gRPC doc <https://github.com/grpc/grpc/blob/master/doc/health-checking.md>`_
// for details.
#HealthCheck_GrpcHealthCheck: {
	// An optional service name parameter which will be sent to gRPC service in
	// `grpc.health.v1.HealthCheckRequest
	// <https://github.com/grpc/grpc/blob/master/src/proto/grpc/health/v1/health.proto#L20>`_.
	// message. See `gRPC health-checking overview
	// <https://github.com/grpc/grpc/blob/master/doc/health-checking.md>`_ for more information.
	service_name?: string
	// The value of the :authority header in the gRPC health check request. If
	// left empty (default value), the name of the cluster this health check is associated
	// with will be used. The authority header can be customized for a specific endpoint by setting
	// the :ref:`hostname <envoy_v3_api_field_config.endpoint.v3.Endpoint.HealthCheckConfig.hostname>` field.
	authority?: string
	// Specifies a list of key-value pairs that should be added to the metadata of each GRPC call
	// that is sent to the health checked cluster. For more information, including details on header value syntax,
	// see the documentation on :ref:`custom request headers
	// <config_http_conn_man_headers_custom_request_headers>`.
	initial_metadata?: [...#HeaderValueOption]
}

// Custom health check.
#HealthCheck_CustomHealthCheck: {
	// The registered name of the custom health checker.
	name?:         string
	typed_config?: any.#Any
}

// Health checks occur over the transport socket specified for the cluster. This implies that if a
// cluster is using a TLS-enabled transport socket, the health check will also occur over TLS.
//
// This allows overriding the cluster TLS settings, just for health check connections.
#HealthCheck_TlsOptions: {
	// Specifies the ALPN protocols for health check connections. This is useful if the
	// corresponding upstream is using ALPN-based :ref:`FilterChainMatch
	// <envoy_v3_api_msg_config.listener.v3.FilterChainMatch>` along with different protocols for health checks
	// versus data connections. If empty, no ALPN protocols will be set on health check connections.
	alpn_protocols?: [...string]
}
