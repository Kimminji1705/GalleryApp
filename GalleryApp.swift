// ============================================================
// GalleryApp.swift
// Punto de entrada principal de la aplicación.
// @main indica a SwiftUI que esta struct es la raíz del ciclo
// de vida de la app.
// ============================================================

import SwiftUI

@main
struct GalleryApp: App {

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            // ContentView actúa como contenedor raíz con NavigationStack
            ContentView()
        }
    }
}
