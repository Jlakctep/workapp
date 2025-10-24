import SwiftUI

struct PeopleView: View {
	@StateObject private var vm = PeopleViewModel()
	var body: some View {
		NavigationStack {
			List(vm.people) { person in
				NavigationLink(destination: StakeholderProfileView(name: person.name, role: person.role)) {
					HStack(spacing: 12) {
						AvatarView(initials: initials(for: person.name))
						VStack(alignment: .leading, spacing: 4) {
							Text(person.name).font(.system(size: 16, weight: .medium)).foregroundColor(DS.ColorPalette.textPrimary)
							Text(person.role).font(.system(size: 13)).foregroundColor(DS.ColorPalette.textSecondary)
						}
					}
				}
				.listRowBackground(DS.ColorPalette.surface2)
			}
			.scrollContentBackground(.hidden)
			.background(DS.ColorPalette.background)
			.navigationTitle("Люди")
			.toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Add") { Task { await vm.addSampleIfEmpty() } } } }
		}
		.darkTheme()
		.task { await vm.load() }
	}
	private func initials(for name: String) -> String {
		let parts = name.split(separator: " ")
		let first = parts.first?.first.map { String($0) } ?? "?"
		let last = parts.dropFirst().first?.first.map { String($0) } ?? ""
		return (first + last).uppercased()
	}
}

private struct AvatarView: View {
	let initials: String
	var body: some View {
		Text(initials)
			.font(.system(size: 16, weight: .semibold))
			.foregroundColor(DS.ColorPalette.textPrimary)
			.frame(width: 40, height: 40)
			.background(
				LinearGradient(colors: [DS.ColorPalette.primary, DS.ColorPalette.secondary], startPoint: .topLeading, endPoint: .bottomTrailing)
			)
			.cornerRadius(20)
	}
}

struct StakeholderProfileView: View {
	let name: String
	let role: String
	@State private var selectedTab: Int = 0
	var body: some View {
		VStack(spacing: 0) {
			Header()
			Segmented(selected: $selectedTab)
			TabView(selection: $selectedTab) {
				ProfileInfoView().tag(0)
				ProfilePlanView().tag(1)
				ProfileHistoryView().tag(2)
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
		}
		.background(DS.ColorPalette.background)
		.navigationBarTitleDisplayMode(.inline)
		.darkTheme()
	}
	@ViewBuilder private func Header() -> some View {
		VStack(spacing: 8) {
			AvatarView(initials: String(name.prefix(1)))
			Text(name).font(.system(size: 22, weight: .semibold)).foregroundColor(DS.ColorPalette.textPrimary)
			Text(role).font(.system(size: 13)).foregroundColor(DS.ColorPalette.textSecondary)
		}
		.padding(16)
	}
}

private struct Segmented: View {
	@Binding var selected: Int
	var body: some View {
		HStack(spacing: 6) {
			SegmentButton(title: "Інфо", index: 0, selected: $selected)
			SegmentButton(title: "План", index: 1, selected: $selected)
			SegmentButton(title: "Історія", index: 2, selected: $selected)
		}
		.padding(6)
		.background(DS.ColorPalette.surface1)
		.overlay(RoundedRectangle(cornerRadius: 10).stroke(DS.ColorPalette.border, lineWidth: 1))
		.cornerRadius(10)
		.padding(.horizontal, 16)
		.padding(.bottom, 8)
	}
}

private struct SegmentButton: View {
	let title: String
	let index: Int
	@Binding var selected: Int
	var body: some View {
		Button(action: { withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) { selected = index } }) {
			Text(title)
				.font(.system(size: 14, weight: .medium))
				.padding(.horizontal, 12)
				.padding(.vertical, 8)
				.frame(maxWidth: .infinity)
				.background(selected == index ? DS.ColorPalette.surface2 : .clear)
				.cornerRadius(8)
		}
	}
}

private struct ProfileInfoView: View { var body: some View { Text("Контакти, матриця, інтерес").foregroundColor(DS.ColorPalette.textSecondary).frame(maxWidth: .infinity, maxHeight: .infinity) } }
private struct ProfilePlanView: View { var body: some View { Text("Стратегія, частота, додати в Home").foregroundColor(DS.ColorPalette.textSecondary).frame(maxWidth: .infinity, maxHeight: .infinity) } }
private struct ProfileHistoryView: View { var body: some View { Text("Таймлайн нотаток/очікувань/документів").foregroundColor(DS.ColorPalette.textSecondary).frame(maxWidth: .infinity, maxHeight: .infinity) } }
