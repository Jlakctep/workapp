import SwiftUI

struct DocsView: View {
	@StateObject private var vm = DocsViewModel()
	var body: some View {
		NavigationStack {
			List {
				if !vm.documents.filter({ $0.status == .draft }).isEmpty {
					Section("Чернетка") { ForEach(vm.documents.filter { $0.status == .draft }) { DocRow(item: $0) } }
				}
				if !vm.documents.filter({ $0.status == .inReview }).isEmpty {
					Section("На узгодженні") { ForEach(vm.documents.filter { $0.status == .inReview }) { DocRow(item: $0) } }
				}
				if !vm.documents.filter({ $0.status == .approved }).isEmpty {
					Section("Затверджено") { ForEach(vm.documents.filter { $0.status == .approved }) { DocRow(item: $0) } }
				}
			}
			.scrollContentBackground(.hidden)
			.background(DS.ColorPalette.background)
			.navigationTitle("Документи")
		}
		.darkTheme()
		.task { await vm.load() }
	}
}

private struct DocRow: View {
	let item: DocumentItem
	var body: some View {
		HStack(alignment: .center, spacing: 12) {
			Image(systemName: "doc.text")
				.foregroundColor(DS.ColorPalette.textSecondary)
			VStack(alignment: .leading, spacing: 4) {
				Text(item.title).font(.system(size: 16, weight: .medium)).foregroundColor(DS.ColorPalette.textPrimary)
				Text(subtitle).font(.system(size: 13)).foregroundColor(DS.ColorPalette.textSecondary)
			}
			Spacer()
			Image(systemName: "chevron.right").foregroundColor(DS.ColorPalette.textSecondary)
		}
		.listRowBackground(DS.ColorPalette.surface2)
	}
	private var subtitle: String {
		let provider = item.provider == .iCloud ? "iCloud" : item.provider == .gDrive ? "Google Drive" : item.provider == .notion ? "Notion" : "Local"
		let status = item.status == .draft ? "Чернетка" : item.status == .inReview ? "На узгодженні" : "Затверджено"
		return provider + " · " + status
	}
}
