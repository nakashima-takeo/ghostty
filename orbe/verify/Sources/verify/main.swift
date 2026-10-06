import GhosttyKit

let info = ghostty_info()
let mode =
  switch info.build_mode {
  case GHOSTTY_BUILD_MODE_DEBUG: "Debug"
  case GHOSTTY_BUILD_MODE_RELEASE_SAFE: "ReleaseSafe"
  case GHOSTTY_BUILD_MODE_RELEASE_FAST: "ReleaseFast"
  case GHOSTTY_BUILD_MODE_RELEASE_SMALL: "ReleaseSmall"
  default: "unknown"
  }
let version = String(
  decoding: UnsafeRawBufferPointer(start: info.version, count: Int(info.version_len)), as: UTF8.self)
print("build_mode=\(mode)")
print("version=\(version)")
