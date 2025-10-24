import SwiftUI

struct NewDocumentView: View {
	@Environment(\.dismiss) private var dismiss
	@State private var template: String = "SOW (UA) v1.3"
	@State private var provider: Int = 0
	@State private var fileName: String = "SOW_Alpha_v1.0_20251024"
	var body: some View {
		NavigationStack {
			Form {
				Picker("Шаблон", selection: $template) {
					Text("SOW (UA) v1.3").tag("SOW (UA) v1.3")
					Text("Статус Звіт").tag("Статус Звіт")
				}
				Picker("Хмара", selection: $provider) {
					Text("iCloud Drive").tag(0)
					Text("Google Drive").tag(1)
					Text("Notion").tag(2)
				}
				TextField("Назва файлу", text: $fileName)
			}
			.navigationTitle("Новий документ")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) { Button("Скасувати") { dismiss() } }
				ToolbarItem(placement: .confirmationAction) { Button("Створити") { Task { await saveAndClose() } } }
			}
		}
		.darkTheme()
	}
	private func saveAndClose() async {
		let p: DocProvider = provider == 0 ? .iCloud : provider == 1 ? .gDrive : .notion
		let doc = DocumentItem(title: fileName, link: nil, provider: p, status: .draft)
		try? await FileDataStore.shared.add(document: doc)
		dismiss()
	}
}
