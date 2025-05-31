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

#ifndef FCMBridge_H
#define FCMBridge_H

#import <Foundation/Foundation.h>
#import <Synpush/Synpush.h>

/// Class (intended to be single-instanced) to provide LLVM C++ service to Swift front-end
@interface Compiler : NSObject

- (nonnull instancetype)init:(nonnull NSArray*)flags;

- (int)compileObject:(nonnull NSString*)filePath
          outputFile:(NSString*)outputFilePath
      platformTriple:(NSString*)platformTriple
              issues:(NSMutableArray<Synitem*> * _Nullable * _Nonnull)issues;

@end

///
/// Function to typecheck code before we compile it to prevent memory leakage before compilation.
///
int typecheck( NSArray * _Nonnull nsargs);

#endif /* FCMBridge_H */
