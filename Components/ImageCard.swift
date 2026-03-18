// ============================================================
// ImageCard.swift
// Componente reutilizable que representa una celda individual
// dentro de la cuadrícula LazyVGrid de GalleryView.
// Carga la imagen de forma asíncrona con AsyncImage.
// ============================================================

import SwiftUI

struct ImageCard: View {

    // MARK: - Dependencies

    /// El modelo de datos que alimenta esta tarjeta
    let item: ImageCard.Item

    /// Modo compacto: reduce el texto al mínimo (usado con 3 columnas)
    var isCompact: Bool = false

    // MARK: - Type Alias (claridad de uso)

    typealias Item = ImageItem

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Imagen con AsyncImage ────────────────────────
            imageSection

            // ── Metadatos debajo de la imagen ────────────────
            if !isCompact {
                metadataSection
            }
        }
        .background(
            RoundedRectangle(cornerRadius: isCompact ? 14 : 18, style: .continuous)
                .fill(Color(red: 0.13, green: 0.13, blue: 0.22))
        )
        .clipShape(RoundedRectangle(cornerRadius: isCompact ? 14 : 18, style: .continuous))
        // Sombra para dar profundidad a la tarjeta
        .shadow(color: Color.black.opacity(0.35), radius: 10, x: 0, y: 5)
    }

    // MARK: - Subviews

    /// Sección de imagen con AsyncImage y sus estados de carga/error
    private var imageSection: some View {
        AsyncImage(url: item.imageURL) { phase in
            switch phase {

            // Estado de carga: shimmer placeholder animado
            case .empty:
                ShimmerView()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1.3, contentMode: .fit)

            // Imagen cargada con éxito
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1.3, contentMode: .fit)
                    .clipped()
                    // Pequeño overlay inferior para legibilidad en modo compacto
                    .overlay(alignment: .bottomLeading) {
                        if isCompact {
                            compactOverlay
                        }
                    }

            // Estado de error: icono sustituto
            case .failure:
                ZStack {
                    Color.white.opacity(0.06)
                    VStack(spacing: 6) {
                        Image(systemName: "photo")
                            .font(.system(size: isCompact ? 22 : 32, weight: .light))
                            .foregroundStyle(Color.white.opacity(0.25))
                        if !isCompact {
                            Text("Sin conexión")
                                .font(.system(size: 11))
                                .foregroundStyle(Color.white.opacity(0.2))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1.3, contentMode: .fit)

            @unknown default:
                EmptyView()
            }
        }
    }

    /// Sección con título y badge de categoría (sólo en modo normal 2 col.)
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 6) {

            // Título de la imagen
            Text(item.title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .truncationMode(.tail)

            // Badge de categoría
            Text(item.category)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color.indigo.opacity(0.9))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule().fill(Color.indigo.opacity(0.18))
                )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    /// Overlay minimalista que aparece sobre la imagen en modo de 3 columnas
    private var compactOverlay: some View {
        LinearGradient(
            colors: [.clear, Color.black.opacity(0.6)],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 36)
    }
}

// MARK: - Preview

#Preview("Normal (2 cols)") {
    HStack(spacing: 12) {
        ImageCard(item: ImageItem.sampleItems[0])
        ImageCard(item: ImageItem.sampleItems[1])
    }
    .padding()
    .background(Color(red: 0.07, green: 0.07, blue: 0.12))
}

#Preview("Compacto (3 cols)") {
    HStack(spacing: 8) {
        ImageCard(item: ImageItem.sampleItems[0], isCompact: true)
        ImageCard(item: ImageItem.sampleItems[1], isCompact: true)
        ImageCard(item: ImageItem.sampleItems[2], isCompact: true)
    }
    .padding()
    .background(Color(red: 0.07, green: 0.07, blue: 0.12))
}
