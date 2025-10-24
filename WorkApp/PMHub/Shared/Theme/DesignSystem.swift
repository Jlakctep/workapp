import SwiftUI

enum DS {
	enum ColorPalette {
		static let background = Color(hex: 0x0A0A10)
		static let surface1 = Color(hex: 0x0F1016)
		static let surface2 = Color(hex: 0x141726)
		static let primary = Color(hex: 0x4A90E2)
		static let secondary = Color(hex: 0x6AE3FF)
		static let textPrimary = Color(hex: 0xEAEAEA)
		static let textSecondary = Color(hex: 0xA8B0C0)
		static let border = Color(hex: 0x262A3D)
		static let success = Color(hex: 0x3AC47A)
		static let warning = Color(hex: 0xFFC857)
		static let danger = Color(hex: 0xFF6B6B)
	}
}

extension Color {
	init(hex: UInt32, alpha: Double = 1.0) {
		let r = Double((hex >> 16) & 0xff) / 255.0
		let g = Double((hex >> 8) & 0xff) / 255.0
		let b = Double(hex & 0xff) / 255.0
		self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
	}
}

struct DarkTheme: ViewModifier {
	func body(content: Content) -> some View {
		content
			.tint(DS.ColorPalette.primary)
			.preferredColorScheme(.dark)
			.background(DS.ColorPalette.background)
	}
}

extension View {
	func darkTheme() -> some View { modifier(DarkTheme()) }
}
