// ============================================================
// ShimmerView.swift
// Efecto de brillo animado (shimmer/skeleton) que se muestra
// mientras se carga una imagen con AsyncImage.
// Simula el contenido mediante un degradado deslizante.
// ============================================================

import SwiftUI

struct ShimmerView: View {

    // MARK: - Animation State

    /// Controla la posición del degradado deslizante (0 = izquierda, 1 = derecha)
    @State private var isAnimating = false

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                // Fondo base del skeleton
                Color.white.opacity(0.06)

                // Degradado deslizante que crea el efecto shimmer
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.00),
                        Color.white.opacity(0.08),
                        Color.white.opacity(0.00)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                // Desplaza el gradiente de izquierda a derecha (-1x a +2x del ancho)
                .offset(x: isAnimating
                    ? geometry.size.width * 2
                    : -geometry.size.width
                )
            }
            .clipped()
        }
        .onAppear {
            // Inicia la animación en bucle infinito
            withAnimation(
                .linear(duration: 1.4)
                .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        ShimmerView()
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 14))

        ShimmerView()
            .frame(height: 20)
            .clipShape(Capsule())
            .padding(.horizontal, 40)
    }
    .padding()
    .background(Color(red: 0.07, green: 0.07, blue: 0.12))
}
