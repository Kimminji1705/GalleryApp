// ============================================================
// CategoryChip.swift
// Chip/pastilla de filtro reutilizable para la barra de
// categorías en GalleryView. Cambia de aspecto según si está
// seleccionado o no.
// ============================================================

import SwiftUI

struct CategoryChip: View {

    // MARK: - Properties

    /// Texto que muestra el chip
    let label: String

    /// Indica si este chip es el filtro activo actualmente
    let isSelected: Bool

    /// Acción a ejecutar al tocar el chip
    let onTap: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                .foregroundStyle(isSelected ? .white : Color.white.opacity(0.55))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(chipBackground)
        }
        .buttonStyle(.plain)
        // Pequeña animación de escala al seleccionar
        .scaleEffect(isSelected ? 1.0 : 0.97)
        .animation(.spring(response: 0.25), value: isSelected)
    }

    // MARK: - Computed Views

    /// Fondo que cambia entre activo (relleno indigo) e inactivo (borde sutil)
    @ViewBuilder
    private var chipBackground: some View {
        if isSelected {
            // Estado activo: degradado sólido
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color.indigo, Color.purple.opacity(0.85)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: Color.indigo.opacity(0.4), radius: 6, x: 0, y: 3)
        } else {
            // Estado inactivo: fondo translúcido con borde
            Capsule()
                .fill(Color.white.opacity(0.07))
                .overlay(
                    Capsule()
                        .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
                )
        }
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 8) {
        CategoryChip(label: "Todas",     isSelected: true)  { }
        CategoryChip(label: "Naturaleza",isSelected: false) { }
        CategoryChip(label: "Viajes",    isSelected: false) { }
    }
    .padding()
    .background(Color(red: 0.07, green: 0.07, blue: 0.12))
}
