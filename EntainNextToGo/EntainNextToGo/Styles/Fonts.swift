//
//  NTGFonts.swift
//  EntainNextToGo
//
//  Created by Sean Smith on 27/2/2024.
//

import SwiftUI

struct Fonts {

    enum Title {
        case large
        case medium
        case small

        var font: Font {
            switch self {
                case .large:
                    return .largeTitle
                case .medium:
                    return .title
                case .small:
                    return .title3
            }
        }
    }

    enum Body {
        case regular
        case caption
        case bold
        case button

        var font: Font {
            switch self {
                case .regular:
                    return .body
                case .bold:
                    return Font.body.bold()
                case .button:
                    return Font.body.weight(.semibold)
                case .caption:
                    return .caption
            }
        }
    }
}


