import SwiftUI

struct NewWaitingView: View {
	@Environment(\.dismiss) private var dismiss
	@State private var what: String = "Чернетка SOW від юриста"
	@State private var who: String = "@Олег"
	@State private var when: Date = .now
	var body: some View {
		NavigationStack {
			Form {
				Section("") {
					TextField("Що", text: $what)
					TextField("Хто (@ім'я)", text: $who)
					DatePicker("Пінганути", selection: $when, displayedComponents: .date)
				}
			}
			.navigationTitle("Нове очікування")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) { Button("Скасувати") { dismiss() } }
				ToolbarItem(placement: .confirmationAction) { Button("Зберегти") { Task { await saveAndClose() } } }
			}
		}
		.darkTheme()
	}
	private func saveAndClose() async {
		let item = WaitingItem(title: what, projectTag: nil, pingAt: when)
		try? await FileDataStore.shared.add(waiting: item)
		dismiss()
	}
}
