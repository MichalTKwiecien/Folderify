import SwiftUI

public extension Color {
    /// #3A0CA3
    static let branding: Color = 0x3A0CA3

    /// #7209B7
    static let brandingDark100: Color = 0x7209B7

    /// #4361EE
    static let brandingLight100: Color = 0x4361EE

    /// #4CC9F0
    static let brandingLight200: Color = 0x4CC9F0

    /// #F72585
    static let danger: Color = 0xF72585

    /// #F8F9FA
    static let light: Color = 0xF8F9FA

    /// #808080
    static let grey: Color = 0x808080

    /// #001233
    static let dark: Color = 0x001233
}

extension Color: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: UInt) {
        self.init(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 08) & 0xFF) / 255,
            blue: Double((value >> 00) & 0xFF) / 255,
            opacity: 1.0
        )
    }
}
