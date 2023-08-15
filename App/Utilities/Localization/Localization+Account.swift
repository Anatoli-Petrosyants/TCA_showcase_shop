//
//  Localization+Account.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.08.23.
//

import SwiftUI

extension Localization {
    enum Account {
        static var title: LocalizedStringKey { return "account.title" }
    
        static var sectionHeaderPersonal: LocalizedStringKey { return "account.section.header.personal" }
        static var sectionHeaderPersonalFirstName: LocalizedStringKey { return "account.section.header.personal.first.name" }
        static var sectionHeaderPersonalLastName: LocalizedStringKey { return "account.section.header.personal.last.name" }
        static var sectionHeaderPersonalBirthDate: LocalizedStringKey { return "account.section.header.personal.birthDate" }
        static var sectionHeaderPersonalGender: LocalizedStringKey { return "account.section.header.personal.gender" }        
        
        static var sectionHeaderContact: LocalizedStringKey { return "account.section.header.contact.contact" }
        static var sectionHeaderContactEmail: LocalizedStringKey { return "account.section.header.contact.email" }
        static var sectionHeaderContactPhone: LocalizedStringKey { return "account.section.header.contact.phone" }
        static var sectionHeaderContactLinkedin: LocalizedStringKey { return "account.section.header.contact.linkedin" }
        static var sectionHeaderContactUpwork: LocalizedStringKey { return "account.section.header.contact.upwork" }
        
        static var sectionHeaderAdditional: LocalizedStringKey { return "account.section.header.additional" }
        static var sectionHeaderAdditionalAboutMe: LocalizedStringKey { return "account.section.header.additional.about.me" }
        static var sectionHeaderAdditionalSupportedVersion: LocalizedStringKey { return "account.section.header.additional.supported.version" }
        static var sectionHeaderAdditionalAppVersion: LocalizedStringKey { return "account.section.header.additional.app.version" }
                
        static var sectionHeaderSettings: LocalizedStringKey { return "account.section.header.settings" }
        static var sectionHeaderSettingsEnableNotifications: LocalizedStringKey { return "account.section.header.settings.enable.notifications" }        
    }
}
