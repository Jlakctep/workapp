import Foundation
import SwiftUI

@MainActor
final class PeopleViewModel: ObservableObject {
	@Published var people: [Person] = []
	func load() async {
		let list = await FileDataStore.shared.getPeople()
		self.people = list
	}
	func addSampleIfEmpty() async {
		if people.isEmpty {
			let p = Person(name: "Віктор Петренко", role: "Клієнт (CEO)")
			try? await FileDataStore.shared.upsert(person: p)
			await load()
		}
	}
}

@MainActor
final class WaitingViewModel: ObservableObject {
	@Published var items: [WaitingItem] = []
	func load() async { self.items = await FileDataStore.shared.getWaiting() }
	func add(title: String) async {
		try? await FileDataStore.shared.add(waiting: WaitingItem(title: title, pingAt: Date()))
		await load()
	}
}

@MainActor
final class DocsViewModel: ObservableObject {
	@Published var documents: [DocumentItem] = []
	func load() async { self.documents = await FileDataStore.shared.getDocuments() }
}
