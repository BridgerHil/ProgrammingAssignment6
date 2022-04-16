//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Bridger Hildreth on 4/15/22.
//

import SwiftUI

struct ThemeChooser: View {
    @EnvironmentObject var store: ThemeStore
    @State private var chosenThemeIndex = 0
    @State private var themeToEdit: Theme?
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: ContentView(viewModel: EmojiMemoryGame(theme: theme))) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                                .foregroundColor(theme.color)
                                .font(.title2)
                            Text(String(theme.numberOfPairs >= theme.emojis.count ? "All" : "\(theme.numberOfPairs)" + " of " + theme.emojis.joined()))
                                .font(.caption)
                        }
                    }
                    .gesture(editMode == .active ? tap(for: theme) : nil)
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
            }
            .sheet(item: $themeToEdit, onDismiss: {
                themeToEdit = nil
                editMode = .inactive
            }) { theme in
                
                ThemeEditor(theme: $store.themes[store.themes.index(matching: theme)!])
            }
            .navigationTitle("Memorize")
            .navigationBarItems(
                leading: Button {
                    chosenThemeIndex = store.insertTheme(named: "New")
//                    themeToEdit = store.theme(at: chosenThemeIndex)
                } label: {
                    Image(systemName: "plus")
                }, trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func tap(for theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            if let matchingIndex = store.themes.index(matching: theme) {
                chosenThemeIndex = matchingIndex
                themeToEdit = store.theme(at: matchingIndex)
            }
        }
    }
}

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}
