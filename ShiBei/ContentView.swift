//
//  ContentView.swift
//  ShiBei
//
//  Created by Xie Zhihao on 2022/6/4.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State var isAdding = false
    @State var sortBy = SortBy.Automatic
    
    @State var id = emptyId
    @State var title = ""
    @State var date = Date.now

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.id)],
        animation: .default)
    var records: FetchedResults<Record>
    
    var sortedRecords: [Record] {
        records.sorted { a, b in
            switch sortBy {
            case .Automatic:
                let aRecommendation = recommend(date: a.date!)
                let bRecommendation = recommend(date: b.date!)
                if aRecommendation == 0 && bRecommendation == 0 {
                    return a.date! > b.date!
                }
                
                return aRecommendation < bRecommendation
            case .Title:
                return a.title! < b.title!
            case .OldestToNewest:
                return a.date! > b.date!
            case .NewestToOldest:
                return a.date! < b.date!
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    ForEach(sortedRecords) {record in
                        RecordView(title: record.title!, date: record.date!)
                            .onTapGesture {
                                self.id = record.id!
                                self.title = record.title!
                                self.date = record.date!
                                self.isAdding = true
                            }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("records")
            .sheet(isPresented: $isAdding) {
                AddView(isPresented: $isAdding, id: $id, title: $title, date: $date) {
                    if id == emptyId {
                        addItem(id: UUID(), title: title, date: date)
                    } else {
                        deleteItem(id: id)
                        addItem(id: id, title: title, date: date)
                    }
                    self.isAdding = false
                } delete: {
                    deleteItem(id: id)
                    self.isAdding = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            withAnimation {
                                self.sortBy = .Automatic
                            }
                        } label: {
                            Label("automatic", systemImage: "star")
                        }
                        Button {
                            withAnimation {
                                self.sortBy = .Title
                            }
                        } label: {
                            Label("title", systemImage: "abc")
                        }
                        Button {
                            withAnimation {
                                self.sortBy = .NewestToOldest
                            }
                        } label: {
                            Label("oldest_to_newest", systemImage: "arrow.up")
                        }
                        Button {
                            withAnimation {
                                self.sortBy = .OldestToNewest
                            }
                        } label: {
                            Label("newest_to_oldest", systemImage: "arrow.down")
                        }
                    } label: {
                        Label("sort_by", systemImage: "arrow.up.arrow.down.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.id = emptyId
                        self.title = ""
                        self.date = Date.now
                        self.isAdding = true
                    } label: {
                        Label("add", systemImage: "plus.circle")
                    }
                }
            }
        }
    }
    
    private func recommend(date: Date) -> Int {
        if date.dayToNow < 0 {
            return 0
        }
        
        let now = Date.now
        let yearDelta = now.get(.year) - date.get(.year)
        if date.isAnniversary {
            return (yearDelta + 1) * anniversaryWeight
        }
        
        let dayToNow = date.dayToNow + 1
        if dayToNow % 100 == 0 {
            return (dayToNow / 100 + 1) * hundredsWeight
        }
        
        if date.isMonthiversary {
            return (yearDelta * 12 + now.get(.month) - date.get(.month) + 1) * monthiversaryWeight
        }
        
        return 0
    }
    
    private func addItem(id: UUID, title: String, date: Date) {
        withAnimation {
            let newRecord = Record(context: viewContext)
            newRecord.id = id
            newRecord.title = title
            newRecord.date = date

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItem(id: UUID) {
        withAnimation {
            let record = records.first { record in
                record.id == id
            }
            guard let record = record else {
                return
            }
            viewContext.delete(record)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
