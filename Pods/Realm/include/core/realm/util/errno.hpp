/*************************************************************************
 *
 * Copyright 2016 Realm Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 **************************************************************************/

#ifndef REALM_UTIL_ERRNO_HPP
#define REALM_UTIL_ERRNO_HPP

#include <string>
#include <realm/util/basic_system_errors.hpp>
#include <realm/util/to_string.hpp>

namespace realm::util {

// Get the error message for a given error code, and append it to `prefix`
inline std::string get_errno_msg(const char* prefix, int err)
{
    return prefix + make_basic_system_error_code(err).message();
}

template <typename... Args>
std::string format_errno(const char* fmt, int err, Args&&... args)
{
    return format(fmt, {Printable(make_basic_system_error_code(err).message()), Printable(args)...});
}

} // namespace realm::util

#endif
