#include <spdlog/sinks/basic_file_sink.h>
#include <spdlog/spdlog.h>

#include "Utils.hpp"

namespace mik {

void createLogger() {
  static std::atomic<bool> hasBeenCalled(false);
  if (hasBeenCalled) {
    return;
  } else {
    hasBeenCalled = true;
  }

  spdlog::set_pattern("[%D:%H:%M:%S.%e] [tid %t] [%s:%#] %v");
  auto logger = spdlog::basic_logger_mt("RistrettoServerLogger", "logs/ristretto-server.log", true);
  spdlog::set_default_logger(logger);
  spdlog::flush_every(std::chrono::seconds(2));
  spdlog::set_level(spdlog::level::debug);
  SPDLOG_DEBUG("Debug-level logging enabled");
}

} // namespace mik