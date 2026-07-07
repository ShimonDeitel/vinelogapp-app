import SwiftUI

/// Bespoke palette for Vinelog -- Track a home vegetable garden's plantings, harvests, and yields.
enum Theme {
    static let accent = Color(hex: "#5B8C3A")
    static let background = Color(hex: "#131A0F")
    static let backgroundSecondary = Color(hex: "#1B2414")
    static let card = Color(hex: "#212E17")
    static let textPrimary = Color(hex: "#EEF5E6")
    static let textSecondary = Color(hex: "#B9CFA0")

    static var titleFont: Font { Font.system(.title2, design: .rounded).weight(.bold) }
    static var bodyFont: Font { Font.system(.body, design: .rounded) }
    static var captionFont: Font { Font.system(.caption, design: .rounded) }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
