// ============================================================
// ScaleButtonStyle.swift
// ButtonStyle personalizado que aplica un efecto de escala
// (reducción suave) al presionar cualquier botón.
// Mejora el feedback háptico/visual en interacciones táctiles.
// ============================================================

import SwiftUI

/// Estilo de botón que reduce ligeramente la escala al presionarlo
struct ScaleButtonStyle: ButtonStyle {

    /// Factor de escala al presionar (0.94 = 6% más pequeño)
    var pressedScale: CGFloat = 0.94

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Aplica la escala: reducida si está presionado, normal en reposo
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0)
            // Leve reducción de opacidad adicional al presionar
            .opacity(configuration.isPressed ? 0.88 : 1.0)
            // Animación suave de spring para que se sienta responsivo
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - View Extension para uso conveniente

extension View {
    /// Atajo para aplicar ScaleButtonStyle con valores por defecto
    func scaleButtonEffect(scale: CGFloat = 0.94) -> some View {
        self.buttonStyle(ScaleButtonStyle(pressedScale: scale))
    }
}
