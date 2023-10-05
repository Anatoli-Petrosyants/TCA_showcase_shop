//
//  NotificationHelper.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 05.09.23.
//

//func registerForRemoteNotificationsAsync(
//  remoteNotifications: RemoteNotificationsClient,
//  userNotifications: UserNotificationClient
//) async {
//  let settings = await userNotifications.getNotificationSettings()
//  guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
//  else { return }
//  await remoteNotifications.register()
//}

func registerForRemoteNotificationsAsync(remoteNotifications: RemoteNotificationsClient) async {
    await remoteNotifications.register()
}
