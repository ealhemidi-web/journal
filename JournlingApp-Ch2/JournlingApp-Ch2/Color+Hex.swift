import SwiftUI

extension Color {
    init?(hex: String) {
        // Remove leading # and whitespace
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        var int: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&int) else { return nil }
        
        let r, g, b, a: UInt64
        switch cleaned.count {
        case 6: // RRGGBB
            (r, g, b, a) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF, 0xFF)
        case 8: // RRGGBBAA
            (r, g, b, a) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self = Color(.sRGB,
                     red: Double(r) / 255.0,
                     green: Double(g) / 255.0,
                     blue: Double(b) / 255.0,
                     opacity: Double(a) / 255.0)
    }
}
