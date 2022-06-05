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
    
    @State var id = UUID.empty
    @State var title = ""
    @State var date = Date.now
    @State var pin = false

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.id)],
        animation: .default)
    var records: FetchedResults<Record>
    
    var sortedRecords: [Record] {
        records.sorted { a, b in
            if a.pin != b.pin {
                return a.pin
            }
            
            switch sortBy {
            case .Automatic:
                let aRecommendation = recommend(date: a.wrappedDate)
                let bRecommendation = recommend(date: b.wrappedDate)
                if aRecommendation == bRecommendation {
                    return a.wrappedDate < b.wrappedDate
                }
                
                return aRecommendation > bRecommendation
            case .Title:
                return a.wrappedTitle < b.wrappedTitle
            case .OldestToNewest:
                return a.wrappedDate > b.wrappedDate
            case .NewestToOldest:
                return a.wrappedDate < b.wrappedDate
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
                
                if records.isEmpty {
                    Text("no_records")
                        .font(.title3)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                } else {
                    ScrollView {
                        ForEach(sortedRecords) {record in
                            RecordView(title: record.wrappedTitle, date: record.wrappedDate, pin: record.pin, recommended: recommend(date: record.wrappedDate) > 0) {
                                self.id = record.wrappedId
                                self.title = record.wrappedTitle
                                self.date = record.wrappedDate
                                self.pin = record.pin
                                self.isAdding = true
                            }
                            .padding(.bottom, 4)
                            .shadow(color: .black.opacity(0.1), radius: 5)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("records")
            .sheet(isPresented: $isAdding) {
                AddView(isPresented: $isAdding, id: $id, title: $title, date: $date, pin: $pin) {
                    if id == UUID.empty {
                        addItem(id: UUID(), title: title, date: date, pin: pin)
                    } else {
                        deleteItem(id: id)
                        addItem(id: id, title: title, date: date, pin: pin)
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
                        self.id = UUID.empty
                        self.title = ""
                        self.date = Date.now
                        self.pin = false
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
            return yearDelta * anniversaryWeight
        }
        
        let dayToNow = date.dayToNow + 1
        if dayToNow % 100 == 0 {
            return dayToNow / 100 * hundredsWeight
        }
        
        if date.isMonthiversary {
            return (yearDelta * 12 + now.get(.month) - date.get(.month)) * monthiversaryWeight
        }
        
        return 0
    }
    
    private func addItem(id: UUID, title: String, date: Date, pin: Bool) {
        withAnimation {
            let newRecord = Record(context: viewContext)
            newRecord.id = id
            newRecord.title = title
            newRecord.date = date
            newRecord.pin = pin

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
