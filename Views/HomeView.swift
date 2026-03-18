// ============================================================
// HomeView.swift
// Pantalla de bienvenida de la aplicación.
// Presenta el título, descripción y el botón principal
// que dispara la navegación hacia GalleryView.
// ============================================================

import SwiftUI

struct HomeView: View {

    // MARK: - Dependencies

    /// Binding al path de navegación del ContentView padre,
    /// necesario para poder empujar nuevas rutas de forma programática.
    @Binding var navigationPath: NavigationPath

    // MARK: - Animation State

    /// Controla la animación de aparición del logo al cargar la vista
    @State private var isLogoVisible  = false
    /// Controla la animación de aparición del contenido de texto
    @State private var isContentVisible = false
    /// Controla la animación del botón principal
    @State private var isButtonVisible  = false

    // MARK: - Body

    var body: some View {
        ZStack {

            // ── Fondo degradado ──────────────────────────────
            backgroundGradient

            // ── Contenido principal ──────────────────────────
            VStack(spacing: 0) {

                Spacer()

                // Sección del logo / ícono hero
                heroIconSection

                Spacer().frame(height: 40)

                // Sección de texto: título + descripción
                textSection

                Spacer().frame(height: 48)

                // Botón principal "Explorar Imágenes"
                exploreButton

                Spacer()

                // Pie de página discreto
                footerText
            }
            .padding(.horizontal, 28)
        }
        .navigationBarHidden(true) // Ocultamos la barra para pantalla inmersiva
        .onAppear { triggerAnimations() } // Dispara las animaciones encadenadas
    }

    // MARK: - Subviews

    /// Fondo con degradado vertical de dos tonos de índigo/azul
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.08, green: 0.08, blue: 0.20), // Azul muy oscuro
                Color(red: 0.15, green: 0.10, blue: 0.35)  // Violeta profundo
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    /// Ícono central animado con anillos decorativos
    private var heroIconSection: some View {
        ZStack {

            // Anillo exterior difuminado
            Circle()
                .fill(Color.indigo.opacity(0.15))
                .frame(width: 200, height: 200)
                .blur(radius: 20)

            // Anillo medio
            Circle()
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                .frame(width: 160, height: 160)

            // Contenedor del ícono
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.indigo, Color.purple.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 110, height: 110)
                .shadow(color: .indigo.opacity(0.6), radius: 20, x: 0, y: 10)

            // SF Symbol: representa la galería de fotos
            Image(systemName: "photo.stack.fill")
                .font(.system(size: 44, weight: .medium))
                .foregroundStyle(.white)
        }
        // Animación de entrada: escala + opacidad
        .scaleEffect(isLogoVisible ? 1.0 : 0.5)
        .opacity(isLogoVisible ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: isLogoVisible)
    }

    /// Bloque de texto: badge de categoría, título principal y subtítulo
    private var textSection: some View {
        VStack(spacing: 16) {

            // Badge superior tipo "etiqueta"
            Text("✦  GALERÍA INTERACTIVA  ✦")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundStyle(Color.indigo.opacity(0.9))
                .kerning(2.5)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.indigo.opacity(0.15))
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.indigo.opacity(0.3), lineWidth: 1)
                        )
                )

            // Título principal
            Text("Descubre el\nMundo Visual")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            // Descripción breve
            Text("Explora una curada colección de fotografías de alta calidad. Cada imagen cuenta una historia única esperando ser descubierta.")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.horizontal, 8)
        }
        // Animación de entrada: deslizamiento desde abajo + opacidad
        .offset(y: isContentVisible ? 0 : 30)
        .opacity(isContentVisible ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(0.25), value: isContentVisible)
    }

    /// Botón principal que navega a la galería
    private var exploreButton: some View {
        Button {
            // Empujamos el array de imágenes al path → activa navigationDestination(for: [ImageItem].self)
            navigationPath.append(ImageItem.sampleItems)
        } label: {
            HStack(spacing: 12) {
                Text("Explorar Imágenes")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))

                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                // Degradado del botón
                LinearGradient(
                    colors: [Color.indigo, Color(red: 0.55, green: 0.20, blue: 0.90)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            // Sombra coloreada para efecto "glow"
            .shadow(color: Color.indigo.opacity(0.55), radius: 15, x: 0, y: 8)
        }
        .buttonStyle(ScaleButtonStyle()) // Efecto de presión (definido abajo)
        // Animación de entrada: deslizamiento desde abajo + opacidad
        .offset(y: isButtonVisible ? 0 : 40)
        .opacity(isButtonVisible ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.45), value: isButtonVisible)
    }

    /// Texto de pie de página con estadísticas ficticias
    private var footerText: some View {
        HStack(spacing: 24) {
            statBadge(value: "12", label: "Imágenes")
            statDivider()
            statBadge(value: "6", label: "Categorías")
            statDivider()
            statBadge(value: "HD", label: "Calidad")
        }
        .padding(.bottom, 32)
        .opacity(isContentVisible ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.5).delay(0.6), value: isContentVisible)
    }

    // MARK: - Helper Views

    private func statBadge(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.45))
        }
    }

    private func statDivider() -> some View {
        Rectangle()
            .fill(Color.white.opacity(0.15))
            .frame(width: 1, height: 28)
    }

    // MARK: - Animation Trigger

    /// Dispara las tres animaciones con retardo escalonado
    private func triggerAnimations() {
        isLogoVisible    = true
        isContentVisible = true
        isButtonVisible  = true
    }
}

// MARK: - Preview

#Preview {
    // Wrapeamos en NavigationStack para que el preview funcione correctamente
    NavigationStack {
        HomeView(navigationPath: .constant(NavigationPath()))
    }
}
