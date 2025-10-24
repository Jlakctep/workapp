import SwiftUI

@resultBuilder
struct FloatingActionMenuBuilder {
	static func buildBlock(_ components: FloatingActionMenu.Item...) -> [FloatingActionMenu.Item] { components }
}

struct FloatingActionMenu: View {
	struct Item: Identifiable {
		let id = UUID()
		let title: String
		let systemImage: String
		let action: () -> Void
	}

	@Binding var isExpanded: Bool
	private let items: [Item]

	init(isExpanded: Binding<Bool>, @FloatingActionMenuBuilder content: () -> [Item]) {
		self._isExpanded = isExpanded
		self.items = content()
	}

	var body: some View {
		GeometryReader { proxy in
			ZStack(alignment: .bottom) {
				if isExpanded {
					Color.black.opacity(0.0001)
						.ignoresSafeArea()
						.onTapGesture { withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) { isExpanded = false } }
				}

				VStack(spacing: 12) {
					if isExpanded {
						ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
							Button(action: {
								withAnimation(.easeInOut(duration: 0.12)) { isExpanded = false }
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { item.action() }
							}) {
								HStack(spacing: 10) {
									Image(systemName: item.systemImage)
										.font(.system(size: 16, weight: .semibold))
										.foregroundColor(DS.ColorPalette.textPrimary)
									Text(item.title)
										.font(.system(size: 15, weight: .medium))
										.foregroundColor(DS.ColorPalette.textPrimary)
								}
								.padding(.horizontal, 14)
								.padding(.vertical, 10)
								.background(DS.ColorPalette.surface2)
								.overlay(
									RoundedRectangle(cornerRadius: 14)
										.stroke(DS.ColorPalette.border, lineWidth: 1)
								)
								.cornerRadius(14)
								.shadow(color: Color.black.opacity(0.6), radius: 14, x: 0, y: 8)
							}
							.transition(.move(edge: .bottom).combined(with: .opacity))
							.animation(.spring(response: 0.28, dampingFraction: 0.85).delay(0.02 * Double(index)), value: isExpanded)
						}
					}

					Button(action: {
						withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) { isExpanded.toggle() }
					}) {
						Image(systemName: isExpanded ? "xmark" : "plus")
							.font(.system(size: 24, weight: .bold))
							.foregroundColor(DS.ColorPalette.textPrimary)
							.frame(width: 64, height: 64)
							.background(DS.ColorPalette.primary)
							.cornerRadius(20)
							.shadow(color: Color.black.opacity(0.6), radius: 28, x: 0, y: 8)
					}
				}
				.frame(maxWidth: .infinity)
				.padding(.bottom, proxy.safeAreaInsets.bottom + 10)
			}
			.ignoresSafeArea(edges: .bottom)
		}
	}
}
