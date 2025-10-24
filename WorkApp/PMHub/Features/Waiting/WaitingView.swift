import SwiftUI

struct WaitingView: View {
	@StateObject private var vm = WaitingViewModel()
	@State private var selectedFilter: String? = nil
	var body: some View {
		NavigationStack {
			List {
				Section {
					ScrollView(.horizontal, showsIndicators: false) {
						HStack(spacing: 8) {
							FilterChip(title: "Всі", isSelected: selectedFilter == nil) { selectedFilter = nil }
							FilterChip(title: "#альфа", isSelected: selectedFilter == "#альфа") { selectedFilter = "#альфа" }
							FilterChip(title: "@Анна", isSelected: selectedFilter == "@Анна") { selectedFilter = "@Анна" }
						}
						.padding(.vertical, 4)
					}
				}
				.listRowInsets(EdgeInsets())

				Section {
					ForEach(vm.items) { item in
						HStack {
							VStack(alignment: .leading, spacing: 6) {
								Text(item.title)
									.font(.system(size: 16, weight: .medium))
									.foregroundColor(DS.ColorPalette.textPrimary)
								Text("Пінганути " + item.pingAt.formatted(date: .abbreviated, time: .omitted))
									.font(.system(size: 13))
									.foregroundColor(DS.ColorPalette.textSecondary)
							}
							Spacer()
							Image(systemName: "chevron.right").foregroundColor(DS.ColorPalette.textSecondary)
						}
						.listRowBackground(DS.ColorPalette.surface2)
					}
				}
			}
			.scrollContentBackground(.hidden)
			.background(DS.ColorPalette.background)
			.navigationTitle("Очікую")
			.toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Add") { Task { await vm.add(title: "Test item") } } } }
		}
		.darkTheme()
		.task { await vm.load() }
	}
}

private struct FilterChip: View {
	let title: String
	let isSelected: Bool
	let action: () -> Void
	var body: some View {
		Button(action: action) {
			Text(title)
				.font(.system(size: 14, weight: .medium))
				.padding(.horizontal, 12)
				.padding(.vertical, 6)
				.background(isSelected ? Color(hex: 0x1B2338) : DS.ColorPalette.surface1)
				.overlay(RoundedRectangle(cornerRadius: 14).stroke(DS.ColorPalette.border, lineWidth: 1))
				.cornerRadius(14)
		}
	}
}
