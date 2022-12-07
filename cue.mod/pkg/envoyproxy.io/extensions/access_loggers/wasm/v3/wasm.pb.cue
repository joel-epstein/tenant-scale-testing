package v3

import (
	v3 "envoyproxy.io/extensions/wasm/v3"
)

// Custom configuration for an :ref:`AccessLog <envoy_v3_api_msg_config.accesslog.v3.AccessLog>`
// that calls into a WASM VM. Configures the built-in *envoy.access_loggers.wasm*
// AccessLog.
#WasmAccessLog: {
	config?: v3.#PluginConfig
}
