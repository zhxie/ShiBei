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

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.date)],
        animation: .default)
    var records: FetchedResults<Record>

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    ForEach(records) {record in
                        RecordView(title: record.title!, date: record.date!)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("records")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {} label: {
                            Label("automatic", systemImage: "star")
                        }
                        Button {
                            records.sortDescriptors = [SortDescriptor(\.title)]
                        } label: {
                            Label("title", systemImage: "abc")
                        }
                        Button {
                            records.sortDescriptors = [SortDescriptor(\.date)]
                        } label: {
                            Label("oldest_to_newest", systemImage: "arrow.up")
                        }
                        Button {
                            records.sortDescriptors = [SortDescriptor(\.date, order: .reverse)]
                        } label: {
                            Label("newest_to_oldest", systemImage: "arrow.down")
                        }
                    } label: {
                        Label("sort_by", systemImage: "arrow.up.arrow.down.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
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
        
        let dayToNow = date.dayToNow
        if dayToNow % 100 == 0 {
            return (dayToNow / 100 + 1) * hundredsWeight
        }
        
        let now = Date.now
        let yearDelta = now.year - date.year
        if date.anniversary {
            return (yearDelta + 1) * anniversaryWeight
        }
        
        if date.monthiversary {
            return (yearDelta * 12 + now.month - date.month + 1) * monthiversaryWeight
        }
        
        return 0
    }
    
    private func addItem(title: String, date: Date) {
        withAnimation {
            let newRecord = Record(context: viewContext)
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { records[$0] }.forEach(viewContext.delete)

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
