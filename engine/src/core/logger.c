#include "logger.h"
#include "asserts.h"
#include "platform/platform.h"

// TODO: Temporary
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

b8 initialize_logging() {
  // TODO: Create log file
  return TRUE;
}

void shutdown_logging(){
  // TODO: Cleanup logging/write queued entries
}

void log_output(log_level level, const char* message, ...) {
  const char* level_strings[6] = {"[FATAL]: ", "[ERROR]: ", "[WARN]:  ", "[INFO]:  ", "[DEBUG]: ", "[TRACE]: "};
  // Handles fatal and error level errors
  b8 is_error = level < LOG_LEVEL_WARN;

  // Technically imposes a 32k character limit on a single log entry, but...
  // dont do this!
  const i32 msg_length = 32000;
  char out_message[msg_length];
  memset(out_message, 0, sizeof(out_message));

  // Format original message.
  // NOTE: MS's headers override the GCC/Clang va_list type with a "typedef char* va_list" in some
  // cases, and as a result throws a strange error here.  The workaround for now is just to use
  // __builtin_va_list, which is the type GGC/Clang's va_start expects.
  __builtin_va_list arg_ptr;
  // Where the Variadic arguments (...) start is right AFTER the message argument
  va_start(arg_ptr, message);
  vsnprintf(out_message, msg_length, message, arg_ptr);
  va_end(arg_ptr);

  char out_message2[msg_length];
  sprintf(out_message2, "%s%s\n", level_strings[level], out_message);

  // Platform-specific output
  if (is_error) {
    platform_console_write_error(out_message2, level);
  } else {
    platform_console_write(out_message2, level);
  }
}

void report_assertion_failure(const char* expression, const char* message, const char* file, i32 line) {
  log_output(LOG_LEVEL_FATAL, "Assertion failure: %s, message: '%s', in file: %s, line: %d\n", expression, message, file, line);
}