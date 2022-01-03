//
//  ContentView.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 25/05/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//

import SwiftUI

private let sorts = [(
    name: "Update Time",
    descriptors: [SortDescriptor(\Entry.lastUpdateTime, order: .reverse)]
), (
    name: "Update Time",
    descriptors: [SortDescriptor(\Entry.lastUpdateTime, order: .forward)]
),  (
    name: "Name",
    descriptors: [SortDescriptor(\Entry.name, order: .forward)]
), (
    name: "Name",
    descriptors: [SortDescriptor(\Entry.name, order: .reverse)]
),]

struct EntryListView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\Entry.lastUpdateTime, order: .reverse),
            SortDescriptor(\Entry.name, order: .forward)
        ],
        animation: .default)
    var entries: FetchedResults<Entry>
    
    @State private var selectedSort = SelectedSort()
    
    @State private var searchText = ""
    var query: Binding<String> {
        Binding {
            searchText
        } set: { newValue in
            searchText = newValue
            entries.nsPredicate = newValue.isEmpty
            ? nil
            : NSPredicate(format: "name CONTAINS %@", newValue)
        }
    }
    
    @State private var showingNewEntry = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(entries, id: \.self) { entry in
                    NavigationLink(
                        destination: EntryDetailView(entry: entry)
                    ) {
                        EntryCellView(entry: entry)
                    }.swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            addEventNow(for: entry)
                        } label: {
                            Image(systemName: "plus.square.on.square")
                                .accessibility(label: Text("Add Event Now"))
                            
                        }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            delete(entry: entry)
                        } label: {
                            Text("Delete")
                        }
                    }
                }
            }
            .searchable(text: query)
            .navigationTitle(Text("Last Time"))
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(
                            action: {
                            self.showingNewEntry.toggle()
                        }
                        ) {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        SortMenu(selection: $selectedSort)
                            .onChange(of: selectedSort) { _ in
                                let sortBy = sorts[selectedSort.index]
                                entries.sortDescriptors = sortBy.descriptors
                            }
                    }
                }
            Text("Detail view content goes here")
                .navigationBarTitle(Text("Detail"))
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .sheet(isPresented: $showingNewEntry) {
            NewEntryView().environment(\.managedObjectContext, self.viewContext)
        }
    }
    
    private func addEventNow(for entry: Entry) {
        withAnimation {
            entry.newEvent(in: self.viewContext)
        }
    }
    
    private func delete(entry: Entry) {
        withAnimation {
            entry.delete(in: self.viewContext)
        }
    }
    
    struct SelectedSort: Equatable {
        var by = 0
        var order = 0
        var index: Int { by + order }
    }
    
    struct SortMenu: View {
        @Binding private var selectedSort: SelectedSort
        
        init(selection: Binding<SelectedSort>) {
            _selectedSort = selection
        }
        
        var body: some View {
            Menu {
                Picker("Sort By", selection: $selectedSort.by) {
                    ForEach(Array(stride(from: 0, to: sorts.count, by: 2)), id: \.self) { index in
                        Text(sorts[index].name).tag(index)
                    }
                }
                Picker("Sort Order", selection: $selectedSort.order) {
                    let sortBy = sorts[selectedSort.by + selectedSort.order]
                    let sortOrders = sortOrders(for: sortBy.name)
                    ForEach(0..<sortOrders.count, id: \.self) { index in
                        Text(sortOrders[index]).tag(index)
                    }
                }
            } label: {
                Label("More", systemImage: "arrow.up.arrow.down")
            }
            .pickerStyle(InlinePickerStyle())
        }
        
        private func sortOrders(for name: String) -> [String] {
            switch name {
            case "Update Time":
                return ["Newest on Top", "Oldest on Top"]
            case "Name":
                return [ "A-Z", "Z-A"]
            default:
                return []
            }
        }
    }
}

struct EntryListView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            
            EntryListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme($0)
        }
    }
}
