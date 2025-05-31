/*
 Copyright (C) 2025 SeanIsTethered

 This file is part of Nyxian.

 FridaCodeManager is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 FridaCodeManager is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with FridaCodeManager. If not, see <https://www.gnu.org/licenses/>.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <mach-o/dyld.h>
#include <mach-o/dyld_images.h>
#include "fishhook.h"

///
/// Definitions of modified functions used to hook existing ones in a dylib
///
extern void dy_exit(int status);
extern int dy_atexit(void (*func)(void));
extern void dy_fprintf(FILE *fptr, const char *format, ...);

///
/// Function to get dylib slide to avoid fucking around with our own symbols
///
intptr_t get_dylib_slide(const char *dylib_name) {
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const char *image_name = _dyld_get_image_name(i);
        if (image_name && strstr(image_name, dylib_name)) {
            intptr_t slide = _dyld_get_image_vmaddr_slide(i);
            return slide;
        }
    }
    return 0;
}

/**
 * @brief Function to create rebinding structs
 *
 */
struct rebinding genrebind(const char *orig,
                           void *symbol)
{
    struct rebinding rebind = {
        .name = orig,
        .replacement = symbol,
    };
    
    return rebind;
}

/**
 * @brief Set up the hooks
 *
 * This function hooks certain symbols like exit and atexit to make a dylib behave like a binariy
 * For example instead of calling real exit it would call our own implementation of it
 */
bool hooker(const char *path)
{
    // First open the dylib layily so we count the reference count up once so it wont get closed before we are done
    void *handle = dlopen(path, RTLD_LAZY);
    
    // If we didnt got any handle we return failure
    if(!handle) return false;
    
    // Preparing the rebinding hooks
    struct rebinding rebindings[] = {
        // to escape exit
        genrebind("exit", dy_exit),
        genrebind("_exit", dy_exit),
        genrebind("atexit", dy_atexit),
        genrebind("fprintf", dy_fprintf)
    };

    // Getting the mach header of the handle we want to hook the symbols of
    const struct mach_header *header = (const struct mach_header *)dlsym(handle, "_mh_execute_header");
    
    // Saving the result of the hooking process
    const bool result = (header != NULL) && (rebind_symbols_image((void*)header, get_dylib_slide(path), rebindings, sizeof(rebindings) / sizeof(rebindings[0])) == 0);
    
    // Closing the handle
    dlclose(handle);
    
    // Returning the result
    return result;
}
