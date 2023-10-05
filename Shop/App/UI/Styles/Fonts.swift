//
//  Fonts.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.02.23.
//

import SwiftUI

extension Font {

    public static var largeTitle: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    }
    
    public static var largeTitleBold: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize,
                           weight: .bold)
    }

    public static var title1: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
    }
    
    public static var title1Bold: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .title1).pointSize,
                           weight: .bold)
    }

    public static var title2: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize)
    }
    
    public static var title2Bold: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize,
                           weight: .bold)
    }

    public static var title3: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
    }
    
    public static var title3Bold: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold)
    }

    public static var headline: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
    }
    
    public static var headlineBold: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .headline).pointSize,
                           weight: .bold)
    }

    public static var subheadline: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
    }
    
    public static var subheadlineBold: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize,
                           weight: .bold)
    }
    
    public static var bodyBold: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize,
                           weight: .bold)
    }

    public static var body: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    }
    
    public static var footnote: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
    }
    
    public static var footnoteBold: Font {
        return Font.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize,
                           weight: .bold)
    }
}
