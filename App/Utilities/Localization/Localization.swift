//
//  Localization.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import SwiftUI

public enum Localization {}

extension Localization {
    enum Base {
        static var showcase: LocalizedStringKey { return "base.showcase" }
        static var `continue`: LocalizedStringKey { return "base.continue" }
        static var ok: LocalizedStringKey { return "base.ok" }
        static var save: LocalizedStringKey { return "base.save" }
        static var logout: LocalizedStringKey { return "base.logout" }
        static var cancel: LocalizedStringKey { return "base.cancel" }
        static var done: LocalizedStringKey { return "base.done" }
        static var attention: LocalizedStringKey { return "base.attention" }
        static var oops: LocalizedStringKey { return "base.oops" }
        static var noNetworkConnection: LocalizedStringKey { return "base.no.network.connection" }
        static var areYouSure: LocalizedStringKey { return "base.are.you.sure" }
        static var successfullySaved: LocalizedStringKey { return "base.successfully.saved" }
        static var emailPlacholder: LocalizedStringKey { return "base.email.placholder" }
    }
}
