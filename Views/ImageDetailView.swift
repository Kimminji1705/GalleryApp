// ============================================================
// ImageDetailView.swift
// Pantalla de detalle de una imagen individual.
// Se accede al tocar cualquier tarjeta en la GalleryView.
// ============================================================

import SwiftUI

struct ImageDetailView: View {

    // MARK: - Dependencies

    /// El ítem de imagen cuyo detalle se muestra
    let item: ImageItem

    // MARK: - View State

    /// Controla si la imagen está en modo zoom (pantalla completa)
    @State private var isZoomed        = false

    /// Escala actual del zoom con gesto de pellizco
    @State private var currentScale: CGFloat = 1.0

    /// Escala base antes de comenzar el gesto de pellizco
    @State private var baseScale: CGFloat    = 1.0

    /// Estado del botón de favorito
    @State private var isFavorite      = false

    /// Controla la animación de aparición del contenido
    @State private var isContentVisible = false

    // MARK: - Body

    var body: some View {
        ZStack {

            // Fondo negro/oscuro para dar protagonismo a la imagen
            Color(red: 0.05, green: 0.05, blue: 0.10)
                .ignoresSafeArea()

            // Contenido principal
            ScrollView {
                VStack(spacing: 0) {

                    // ── Imagen hero con efectos ──────────────
                    heroImage

                    // ── Panel de información ─────────────────
                    infoPanel
                        .offset(y: isContentVisible ? 0 : 30)
                        .opacity(isContentVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.45).delay(0.2), value: isContentVisible)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            Color(red: 0.05, green: 0.05, blue: 0.10),
            for: .navigationBar
        )
        .toolbarColorScheme(.dark, for: .navigationBar)
        // Botón de favorito en la barra de herramientas
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                favoriteButton
            }
        }
        .onAppear { isContentVisible = true }
    }

    // MARK: - Subviews

    /// Imagen principal con carga asíncrona, gestos de zoom y overlay
    private var heroImage: some View {
        GeometryReader { proxy in
            AsyncImage(url: item.imageURL) { phase in
                switch phase {

                case .empty:
                    // Estado de carga: indicador animado
                    loadingPlaceholder(size: proxy.size)

                case .success(let image):
                    // Imagen cargada exitosamente
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.width * 0.72)
                        .clipped()
                        // Overlay con gradiente en la parte inferior (para texto)
                        .overlay(alignment: .bottom) {
                            heroOverlay
                        }
                        // Efecto escala al hacer zoom
                        .scaleEffect(currentScale)
                        // Gesto de pellizco para zoom interactivo
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    currentScale = min(max(baseScale * value, 1.0), 4.0)
                                }
                                .onEnded { _ in
                                    // Si el zoom es pequeño, regresa a 1x
                                    if currentScale < 1.2 {
                                        withAnimation(.spring()) { currentScale = 1.0 }
                                    }
                                    baseScale = currentScale
                                }
                        )
                        // Doble toque para alternar zoom 1x / 2x
                        .onTapGesture(count: 2) {
                            withAnimation(.spring(response: 0.4)) {
                                if currentScale > 1.0 {
                                    currentScale = 1.0
                                    baseScale    = 1.0
                                } else {
                                    currentScale = 2.0
                                    baseScale    = 2.0
                                }
                            }
                        }

                case .failure:
                    // Estado de error: icono informativo
                    errorPlaceholder(size: proxy.size)

                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.width * 0.72)
            .clipShape(RoundedRectangle(cornerRadius: 0)) // Borde a borde en detalle
        }
        // Alto calculado con aspectRatio para consistencia en diferentes pantallas
        .aspectRatio(1.38, contentMode: .fit)
    }

    /// Gradiente semi-transparente sobre la parte inferior de la imagen hero
    private var heroOverlay: some View {
        LinearGradient(
            colors: [.clear, Color.black.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 80)
    }

    /// Panel inferior con metadatos, estadísticas y acciones
    private var infoPanel: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Cabecera: categoría + título ─────────────────
            headerSection

            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.vertical, 20)

            // ── Estadísticas ficticias ───────────────────────
            statsSection

            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.vertical, 20)

            // ── Descripción ──────────────────────────────────
            descriptionSection

            Spacer().frame(height: 32)

            // ── Botones de acción ────────────────────────────
            actionButtons
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .background(
            // Fondo del panel con leve elevación
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(red: 0.10, green: 0.10, blue: 0.17))
                .ignoresSafeArea(edges: .bottom)
        )
        // Sube el panel 24pt sobre la imagen para efecto "card sheet"
        .offset(y: -24)
    }

    /// Sección con badge de categoría y título de la imagen
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Badge de categoría
            Text(item.category.uppercased())
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(.indigo)
                .kerning(2)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule().fill(Color.indigo.opacity(0.18))
                )

            // Título
            Text(item.title)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            // Subtítulo (ID de imagen para debug, o fuente)
            Text("ID: \(item.id.uuidString.prefix(8).uppercased())")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(Color.white.opacity(0.3))
        }
    }

    /// Fila de estadísticas ilustrativas de la imagen
    private var statsSection: some View {
        HStack(spacing: 0) {
            StatCard(icon: "eye.fill",       value: "2.4K", label: "Vistas",     color: .cyan)
            StatCard(icon: "heart.fill",     value: "381",  label: "Favoritos",  color: .pink)
            StatCard(icon: "arrow.down.circle.fill", value: "128", label: "Descargas", color: .green)
        }
    }

    /// Sección de descripción con texto de placeholder
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Descripción")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.5))
                .textCase(.uppercase)
                .kerning(1.5)

            Text("Una impresionante fotografía de la categoría **\(item.category)** que captura la esencia visual de \"\(item.title)\" con una composición cuidada y una paleta de colores excepcional.")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.white.opacity(0.7))
                .lineSpacing(6)
        }
    }

    /// Botones de acción: Compartir y Descargar
    private var actionButtons: some View {
        HStack(spacing: 12) {

            // Botón Compartir (funcional con ShareLink de iOS 16+)
            ShareLink(item: item.imageURL, subject: Text(item.title)) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Compartir")
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.1))
                )
            }

            // Botón Descargar (botón decorativo para demostración)
            Button {
                // Aquí iría la lógica de descarga real
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.down.to.line")
                    Text("Guardar")
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color.indigo, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                )
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.bottom, 40) // Espacio extra para el home indicator
    }

    /// Botón de favorito en la toolbar con animación de corazón
    private var favoriteButton: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.55)) {
                isFavorite.toggle()
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(isFavorite ? Color.pink : Color.white)
                .symbolEffect(.bounce, value: isFavorite)
        }
    }

    // MARK: - Placeholder Views

    private func loadingPlaceholder(size: CGSize) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.07))
            ProgressView()
                .tint(.white)
                .scaleEffect(1.4)
        }
        .frame(width: size.width, height: size.width * 0.72)
    }

    private func errorPlaceholder(size: CGSize) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.05))
            VStack(spacing: 10) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.white.opacity(0.3))
                Text("No se pudo cargar")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.white.opacity(0.3))
            }
        }
        .frame(width: size.width, height: size.width * 0.72)
    }
}

// MARK: - StatCard Component

/// Tarjeta de estadística individual usada en el panel de detalle
struct StatCard: View {
    let icon:  String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ImageDetailView(item: ImageItem.sampleItems[0])
    }
    .preferredColorScheme(.dark)
}
