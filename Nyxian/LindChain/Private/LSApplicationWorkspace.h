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

#import <Foundation/Foundation.h>

@interface LSApplicationWorkspace : NSObject
+ (LSApplicationWorkspace *)defaultWorkspace;
- (void)_sf_openURL:(id)arg1 withOptions:(id)arg2 completionHandler:(/*^block*/ id)arg3;
- (id)operationToOpenResource:(id)arg1 usingApplication:(id)arg2 userInfo:(id)arg3;
@property (nonatomic, readonly) BOOL establishConnection;
@property (nonatomic, readonly, strong) id remoteObserver;
- (id)pluginsWithIdentifiers:(id)arg1 protocols:(id)arg2 version:(id)arg3 applyFilter:(/*^block*/ id)arg4;
- (id)operationToOpenResource:(id)arg1 usingApplication:(id)arg2 uniqueDocumentIdentifier:(id)arg3 userInfo:(id)arg4;
- (BOOL)installApplication:(id)arg1 withOptions:(id)arg2 error:(id *)arg3 usingBlock:(/*^block*/ id)arg4;
- (id)installProgressForApplication:(id)arg1 withPhase:(unsigned long long)arg2;
- (BOOL)registerApplicationDictionary:(id)arg1 withObserverNotification:(int)arg2;
- (BOOL)installPhaseFinishedForProgress:(id)arg1;
- (unsigned long long)getInstallTypeForOptions:(id)arg1 andApp:(id)arg2;
- (id)installBundle:(id)arg1
           withOptions:(id)arg2
            usingBlock:(/*^block*/ id)arg3
                forApp:(id)arg4
             withError:(id *)arg5
    outInstallProgress:(id *)arg6;
- (BOOL)uninstallApplication:(id)arg1 withOptions:(id)arg2 usingBlock:(/*^block*/ id)arg3;
- (BOOL)registerBundleWithInfo:(id)arg1 options:(id)arg2 type:(unsigned long long)arg3 progress:(id)arg4;
- (void)clearCreatedProgressForBundleID:(id)arg1;
- (void)removeInstallProgressForBundleID:(id)arg1;
- (void)getKnowledgeUUID:(id *)arg1 andSequenceNumber:(id *)arg2;
@property (nonatomic, readonly, assign) id delegateProxy;
@property (nonatomic, readonly, strong) id directionsApplications;
@property (nonatomic, readonly, strong) id applicationsWithAudioComponents;
@property (nonatomic, readonly, strong) id applicationsWithSettingsBundle;
@property (nonatomic, readonly, strong) id applicationsWithVPNPlugins;
@property (nonatomic, readonly, strong) id applicationsWithExternalAccessoryProtocols;
- (id)applicationForUserActivityType:(id)arg1;
- (id)applicationForUserActivityDomainName:(id)arg1;
- (id)pluginsWithIdentifiers:(id)arg1 protocols:(id)arg2 version:(id)arg3 withFilter:(/*^block*/ id)arg4;
- (id)pluginsWithIdentifiers:(id)arg1 protocols:(id)arg2 version:(id)arg3;
- (void)openUserActivity:(id)arg1 withApplicationProxy:(id)arg2 completionHandler:(/*^block*/ id)arg3;
@property (nonatomic, readonly, strong) id installedVPNPlugins;
@property (nonatomic, readonly, strong) id unrestrictedApplications;
@property (nonatomic, readonly, strong) id publicURLSchemes;
- (BOOL)getClaimedActivityTypes:(id *)arg1 domains:(id *)arg2;
- (BOOL)installApplication:(id)arg1 withOptions:(id)arg2;
- (BOOL)installApplication:(id)arg1 withOptions:(id)arg2 error:(id *)arg3;
- (BOOL)downgradeApplicationToPlaceholder:(id)arg1 withOptions:(id)arg2 error:(id *)arg3;
- (BOOL)registerApplicationDictionary:(id)arg1;
- (BOOL)registerApplication:(id)arg1;
- (BOOL)unregisterApplication:(id)arg1;
- (BOOL)registerPlugin:(id)arg1;
- (BOOL)unregisterPlugin:(id)arg1;
- (BOOL)updateSINFWithData:(id)arg1 forApplication:(id)arg2 options:(id)arg3 error:(id *)arg4;
- (BOOL)invalidateIconCache:(id)arg1;
- (void)_clearCachedAdvertisingIdentifier;
@property (nonatomic, readonly, strong) id deviceIdentifierForAdvertising;
- (id)installProgressForBundleID:(id)arg1 makeSynchronous:(unsigned char)arg2;
- (BOOL)_LSPrivateRebuildApplicationDatabasesForSystemApps:(BOOL)arg1 internal:(BOOL)arg2 user:(BOOL)arg3;
- (id)applicationForOpeningResource:(id)arg1;
- (void)addObserver:(id)arg1;
- (BOOL)isApplicationAvailableToOpenURL:(id)arg1 error:(id *)arg2;
- (id)applicationsAvailableForHandlingURLScheme:(id)arg1;
@property (nonatomic, readonly, strong) id privateURLSchemes;
- (id)URLOverrideForURL:(id)arg1;
- (BOOL)openURL:(id)arg1;
- (void)removeObserver:(id)arg1;
- (id)operationToOpenResource:(id)arg1
             usingApplication:(id)arg2
     uniqueDocumentIdentifier:(id)arg3
                     userInfo:(id)arg4
                     delegate:(id)arg5;
@property (nonatomic, readonly, strong) id deviceIdentifierForVendor;
- (id)applicationsAvailableForOpeningDocument:(id)arg1;
- (id)operationToOpenResource:(id)arg1
             usingApplication:(id)arg2
     uniqueDocumentIdentifier:(id)arg3
              sourceIsManaged:(BOOL)arg4
                     userInfo:(id)arg5
                     delegate:(id)arg6;
- (BOOL)openURL:(id)arg1 withOptions:(id)arg2;
- (BOOL)openSensitiveURL:(id)arg1 withOptions:(id)arg2;
@property (nonatomic, readonly, strong) id allInstalledApplications;
- (id)applicationsOfType:(unsigned long long)arg1;
- (void)enumerateBundlesOfType:(unsigned long long)arg1 usingBlock:(/*^block*/ id)arg2;
- (BOOL)uninstallApplication:(id)arg1 withOptions:(id)arg2;
@property (nonatomic, readonly, strong) id placeholderApplications;
- (BOOL)applicationIsInstalled:(id)arg1;
@property (nonatomic, readonly, strong) id installedPlugins;
- (void)_LSClearSchemaCaches;
- (void)clearAdvertisingIdentifier;
@property (nonatomic, readonly, strong) id applicationsWithUIBackgroundModes;
//@property (nonatomic, readonly, copy) NSArray<FBApplicationInfo *> *allApplications;
- (BOOL)openApplicationWithBundleID:(id)arg1;
- (BOOL)openSensitiveURL:(id)arg1 withOptions:(id)arg2 error:(id *)arg3;
- (BOOL)openURL:(id)arg1 withOptions:(id)arg2 error:(id *)arg3;
@end
