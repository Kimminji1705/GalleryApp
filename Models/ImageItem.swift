// ============================================================
// ImageItem.swift
// Modelo de datos que representa una imagen en la galería.
// Conforme a Identifiable para usarlo en listas/grids de SwiftUI
// y a Hashable para poder usarlo como destino de NavigationStack.
// ============================================================

import Foundation

/// Estructura de datos que representa un ítem de imagen
struct ImageItem: Identifiable, Hashable {

    // MARK: - Propiedades

    /// Identificador único autogenerado
    let id: UUID

    /// Título descriptivo de la imagen
    let title: String

    /// Categoría o etiqueta temática
    let category: String

    /// URL remota de la imagen (usando picsum.photos como placeholder)
    let imageURL: URL

    // MARK: - Inicializador

    /// Inicializador con `id` opcional para facilitar la creación en previsualizaciones
    init(id: UUID = UUID(), title: String, category: String, imageURL: URL) {
        self.id         = id
        self.title      = title
        self.category   = category
        self.imageURL   = imageURL
    }
}

// MARK: - Datos de Muestra

extension ImageItem {

    /// Colección estática de imágenes de ejemplo para uso en previsualizaciones y pruebas.
    /// Cada URL de picsum.photos devuelve una imagen aleatoria del tamaño indicado.
    static let sampleItems: [ImageItem] = [
        ImageItem(
            title: "Montañas Nevadas",
            category: "Naturaleza",
            imageURL: URL(string: "https://picsum.photos/seed/mountain/400/300")!
        ),
        ImageItem(
            title: "Ciudad de Noche",
            category: "Arquitectura",
            imageURL: URL(string: "https://picsum.photos/seed/city/400/300")!
        ),
        ImageItem(
            title: "Bosque Misterioso",
            category: "Naturaleza",
            imageURL: URL(string: "https://picsum.photos/seed/forest/400/300")!
        ),
        ImageItem(
            title: "Playa Tropical",
            category: "Viajes",
            imageURL: URL(string: "https://picsum.photos/seed/beach/400/300")!
        ),
        ImageItem(
            title: "Café Artesanal",
            category: "Gastronomía",
            imageURL: URL(string: "https://picsum.photos/seed/coffee/400/300")!
        ),
        ImageItem(
            title: "Desierto al Atardecer",
            category: "Naturaleza",
            imageURL: URL(string: "https://picsum.photos/seed/desert/400/300")!
        ),
        ImageItem(
            title: "Puente Histórico",
            category: "Arquitectura",
            imageURL: URL(string: "https://picsum.photos/seed/bridge/400/300")!
        ),
        ImageItem(
            title: "Mercado Local",
            category: "Cultura",
            imageURL: URL(string: "https://picsum.photos/seed/market/400/300")!
        ),
        ImageItem(
            title: "Cascada Cristalina",
            category: "Naturaleza",
            imageURL: URL(string: "https://picsum.photos/seed/waterfall/400/300")!
        ),
        ImageItem(
            title: "Skyline Urbano",
            category: "Arquitectura",
            imageURL: URL(string: "https://picsum.photos/seed/skyline/400/300")!
        ),
        ImageItem(
            title: "Flores de Primavera",
            category: "Naturaleza",
            imageURL: URL(string: "https://picsum.photos/seed/flowers/400/300")!
        ),
        ImageItem(
            title: "Noche Estrellada",
            category: "Astronomía",
            imageURL: URL(string: "https://picsum.photos/seed/stars/400/300")!
        )
    ]
}
