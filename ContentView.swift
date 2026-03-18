// ============================================================
// ContentView.swift
// Vista raíz que configura el NavigationStack.
// NavigationStack (iOS 16+) reemplaza a NavigationView y
// gestiona el stack de navegación de forma declarativa
// mediante un array de path tipado.
// ============================================================

import SwiftUI

struct ContentView: View {

    // MARK: - Navigation State

    /// Path que controla el stack de navegación.
    /// Cuando se añade un valor, SwiftUI navega a la vista
    /// registrada para ese tipo mediante navigationDestination.
    @State private var navigationPath = NavigationPath()

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationPath) {

            // Vista inicial: pantalla de bienvenida
            HomeView(navigationPath: $navigationPath)

                // MARK: Destinos de Navegación
                // Vincula el tipo `[ImageItem]` con GalleryView
                .navigationDestination(for: [ImageItem].self) { items in
                    GalleryView(items: items, navigationPath: $navigationPath)
                }
                // Vincula el tipo `ImageItem` con ImageDetailView
                .navigationDestination(for: ImageItem.self) { item in
                    ImageDetailView(item: item)
                }
        }
        // Aplica el estilo de navegación a nivel global
        .tint(.indigo) // Color de acento para botones de navegación
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
