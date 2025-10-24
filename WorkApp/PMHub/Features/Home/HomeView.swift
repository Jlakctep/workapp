import SwiftUI

struct HomeView: View {
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 16) {
					SectionHeader(title: "Пінги на сьогодні")
					PlaceholderCard(title: "Чекаю на ТЗ від Анни", subtitle: "Проєкт: Альфа")

					SectionHeader(title: "Ключові комунікації")
					PlaceholderCard(title: "Щотижневий звіт для Віктора", subtitle: "CRM → План")

					SectionHeader(title: "Гарячі документи")
					PlaceholderCard(title: "SOW v1.2", subtitle: "Очікуємо: Анна, Олег")
				}
				.padding(16)
			}
			.background(DS.ColorPalette.background)
			.navigationTitle("Сьогодні")
		}
		.darkTheme()
	}
}

private struct SectionHeader: View {
	let title: String
	var body: some View {
		HStack {
			Text(title)
				.font(.system(size: 18, weight: .semibold))
				.foregroundColor(DS.ColorPalette.textPrimary)
			Spacer()
		}
	}
}

private struct PlaceholderCard: View {
	let title: String
	let subtitle: String
	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(title)
				.font(.system(size: 16, weight: .medium))
				.foregroundColor(DS.ColorPalette.textPrimary)
			Text(subtitle)
				.font(.system(size: 14, weight: .regular))
				.foregroundColor(DS.ColorPalette.textSecondary)
		}
		.padding(16)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(DS.ColorPalette.surface2)
		.overlay(
			RoundedRectangle(cornerRadius: 12).stroke(DS.ColorPalette.border, lineWidth: 1)
		)
		.cornerRadius(12)
	}
}
