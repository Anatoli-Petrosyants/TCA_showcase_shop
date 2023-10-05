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
    
        static var sectionPersonal: LocalizedStringKey { return "account.section.personal" }
        static var sectionPersonalFirstName: LocalizedStringKey { return "account.section.personal.first.name" }
        static var sectionPersonalLastName: LocalizedStringKey { return "account.section.personal.last.name" }
        static var sectionPersonalBirthDate: LocalizedStringKey { return "account.section.personal.birthDate" }
        static var sectionPersonalGender: LocalizedStringKey { return "account.section.personal.gender" }
        
        static var sectionCity: LocalizedStringKey { return "account.section.city" }
        static var sectionCityPlacholder: LocalizedStringKey { return "account.section.city.placholder" }
        static var sectionCityFooter: LocalizedStringKey { return "account.section.city.footer" }                
        
        static var sectionContact: LocalizedStringKey { return "account.section.contact" }
        static var sectionContactEmail: LocalizedStringKey { return "account.section.contact.email" }
        static var sectionContactPhone: LocalizedStringKey { return "account.section.contact.phone" }
        static var sectionContactLinkedin: LocalizedStringKey { return "account.section.contact.linkedin" }
        static var sectionContactUpwork: LocalizedStringKey { return "account.section.contact.upwork" }
        
        static var sectionAdditional: LocalizedStringKey { return "account.section.additional" }
        static var sectionAdditionalAboutMe: LocalizedStringKey { return "account.section.additional.about.me" }
        static var sectionAdditionalSupportedVersion: LocalizedStringKey { return "account.section.additional.supported.version" }
        static var sectionAdditionalAppVersion: LocalizedStringKey { return "account.section.additional.app.version" }
                
        static var sectionSettings: LocalizedStringKey { return "account.section.settings" }
        static var sectionSettingsEnableNotifications: LocalizedStringKey { return "account.section.settings.enable.notifications" }
    }
}
