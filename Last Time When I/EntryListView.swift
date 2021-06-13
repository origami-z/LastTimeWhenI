//
//  ContentView.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 25/05/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//

import SwiftUI

struct EntryListView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var showingNewEntry = false
    
    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text("Last Time"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                    //                            withAnimation { Event.create(in: self.viewContext) }
                    self.showingNewEntry.toggle()
                }
                    ) {
                    Image(systemName: "plus")
                }
                )
            Text("Detail view content goes here")
                .navigationBarTitle(Text("Detail"))
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .sheet(isPresented: $showingNewEntry) {
            NewEntryView().environment(\.managedObjectContext, self.viewContext)
        }
    }
}

private let sorts = [(
    name: "Update Time",
    descriptors: [SortDescriptor(\Entry.lastUpdateTime, order: .reverse)]
), (
    name: "Update Time",
    descriptors: [SortDescriptor(\Entry.lastUpdateTime, order: .forward)]
), (
    name: "Name",
    descriptors: [SortDescriptor(\Entry.name, order: .reverse)]
), (
    name: "Name",
    descriptors: [SortDescriptor(\Entry.name, order: .forward)]
)]

struct MasterView: View {
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
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    var body: some View {
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                SortMenu(selection: $selectedSort)
                .onChange(of: selectedSort) { _ in
                    let sortBy = sorts[selectedSort.index]
                    entries.sortDescriptors = sortBy.descriptors
                }
            }
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
                Label("More", systemImage: "ellipsis.circle")
            }
            .pickerStyle(InlinePickerStyle())
        }
        
        private func sortOrders(for name: String) -> [String] {
            switch name {
            case "Update Time":
                return ["Newest on Top", "Oldest on Top"]
            case "Name":
                return ["Z-A", "A-Z"]
            default:
                return []
            }
        }
    }
}

struct EntryListView_Previews: PreviewProvider {
    static var previews: some View {
        EntryListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
