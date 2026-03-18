// ============================================================
// GalleryView.swift
// Pantalla principal de la galería.
// Muestra una cuadrícula adaptativa de imágenes con
// LazyVGrid para carga eficiente bajo demanda.
// ============================================================

import SwiftUI

struct GalleryView: View {

    // MARK: - Dependencies

    /// Lista de ítems de imagen a mostrar en la cuadrícula
    let items: [ImageItem]

    /// Binding al path de navegación para la navegación programática
    @Binding var navigationPath: NavigationPath

    // MARK: - View State

    /// Número de columnas activo según el modo seleccionado
    @State private var columnCount: Int = 2

    /// Texto del campo de búsqueda
    @State private var searchText: String = ""

    /// Categoría seleccionada para filtrado (nil = todas)
    @State private var selectedCategory: String? = nil

    /// Controla la aparición animada de las tarjetas
    @State private var isGridVisible = false

    // MARK: - Computed Properties

    /// Categorías únicas extraídas del modelo de datos
    private var categories: [String] {
        Array(Set(items.map(\.category))).sorted()
    }

    /// Ítems filtrados según búsqueda y categoría activa
    private var filteredItems: [ImageItem] {
        items.filter { item in
            let matchesSearch = searchText.isEmpty ||
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.category.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedCategory == nil ||
                item.category == selectedCategory

            return matchesSearch && matchesCategory
        }
    }

    /// Definición de columnas para LazyVGrid según el modo seleccionado
    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 12), count: columnCount)
    }

    // MARK: - Body

    var body: some View {
        ZStack {

            // Fondo oscuro uniforme
            Color(red: 0.07, green: 0.07, blue: 0.12)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Chips de categorías ──────────────────────
                categoryFilterBar
                    .padding(.top, 8)

                // ── Cuadrícula de imágenes ───────────────────
                if filteredItems.isEmpty {
                    emptyStateView
                } else {
                    imageGrid
                }
            }
        }
        // Barra de búsqueda nativa integrada en el NavigationStack
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Buscar por título o categoría…"
        )
        .navigationTitle("Galería")
        .navigationBarTitleDisplayMode(.large)
        // Botón para alternar entre cuadrícula de 2 y 3 columnas
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                columnToggleButton
            }
        }
        // Estilo de la barra de navegación
        .toolbarBackground(
            Color(red: 0.07, green: 0.07, blue: 0.12),
            for: .navigationBar
        )
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { isGridVisible = true }
    }

    // MARK: - Subviews

    /// Barra horizontal de chips para filtrar por categoría
    private var categoryFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {

                // Chip "Todas"
                CategoryChip(
                    label: "Todas",
                    isSelected: selectedCategory == nil
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedCategory = nil
                    }
                }

                // Un chip por cada categoría única
                ForEach(categories, id: \.self) { category in
                    CategoryChip(
                        label: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedCategory = category == selectedCategory ? nil : category
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    /// Cuadrícula principal usando LazyVGrid
    private var imageGrid: some View {
        ScrollView {
            // Contador de resultados
            HStack {
                Text("\(filteredItems.count) resultado\(filteredItems.count == 1 ? "" : "s")")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.45))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            // LazyVGrid: sólo renderiza las celdas visibles en pantalla
            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(Array(filteredItems.enumerated()), id: \.element.id) { index, item in

                    // NavigationLink programático: añade el item al path
                    Button {
                        navigationPath.append(item)
                    } label: {
                        // Tarjeta de imagen (componente reutilizable)
                        ImageCard(item: item, isCompact: columnCount == 3)
                    }
                    .buttonStyle(.plain)
                    // Animación de aparición escalonada por índice
                    .opacity(isGridVisible ? 1.0 : 0.0)
                    .offset(y: isGridVisible ? 0 : 20)
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.8)
                            .delay(Double(index) * 0.04),
                        value: isGridVisible
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        // Quitar el rebote gris en scroll (iOS 16+)
        .scrollContentBackground(.hidden)
    }

    /// Vista que se muestra cuando no hay resultados de búsqueda
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "magnifyingglass")
                .font(.system(size: 50, weight: .light))
                .foregroundStyle(Color.white.opacity(0.3))

            Text("Sin resultados")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.6))

            Text("Prueba con otro término\no elimina los filtros activos")
                .font(.system(size: 14))
                .foregroundStyle(Color.white.opacity(0.35))
                .multilineTextAlignment(.center)

            Button("Limpiar filtros") {
                withAnimation {
                    searchText      = ""
                    selectedCategory = nil
                }
            }
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.indigo)
            .padding(.top, 4)

            Spacer()
        }
        .padding()
    }

    /// Botón en la barra de herramientas para cambiar número de columnas
    private var columnToggleButton: some View {
        Button {
            withAnimation(.spring(response: 0.35)) {
                columnCount = columnCount == 2 ? 3 : 2
            }
        } label: {
            Image(systemName: columnCount == 2 ? "square.grid.3x3" : "square.grid.2x2")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .contentTransition(.symbolEffect(.replace))
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        GalleryView(
            items: ImageItem.sampleItems,
            navigationPath: .constant(NavigationPath())
        )
    }
    .preferredColorScheme(.dark)
}
