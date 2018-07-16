//
//  GlobalVariables.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/11/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation

var GLOBAL_SPEAK_LANGUAGE                   = "en-US"

let GLOBAL_GOOGLE_APIAI_CLIENT_TOKEN        = "7a93fa587b5149f18fa58519c37a5013"

let GLOBAL_APP_INTERNAL_NOTIFICATION_KEY    = "COM.ACTION_HANDLER_TO_VIEW_NOTIFICATION"


var GLOBAL_IS_MUTE_MODE                     = true



enum NotificationTypes:Int {
    case CONNECTING = 99,
    CONNECTED,
    DISCONNECTING,
    DISCONNECTED,
    RECONNECTING,
    RECONNECTED,
    CONNECTION_ERROR,
    DISCONNECTION_ERROR,
    ERROR,
    ANSWER,
    ENTERED_BACKGROUND,
    ENTERED_FOREGROUND,
    PROGRESS_BAR_UPDATE
}

struct NotificationMessage {
    var NotifyType:         NotificationTypes?
    var NotifyMessage:      String?
}

let awsResponseHndlrObj = AWSResponseHandler()

