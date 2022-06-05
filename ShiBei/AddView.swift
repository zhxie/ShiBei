//
//  AddView.swift
//  ShiBei
//
//  Created by Xie Zhihao on 2022/6/5.
//

import SwiftUI

struct AddView: View {
    @Binding var isPresented: Bool
    @Binding var id: UUID
    @Binding var title: String
    @Binding var date: Date
    var done: () -> Void
    var delete: () -> Void

    init(isPresented: Binding<Bool>, id: Binding<UUID>, title: Binding<String>, date: Binding<Date>, done: @escaping () -> Void, delete: @escaping () -> Void) {
        UITableView.appearance().sectionFooterHeight = 0
        self._isPresented = isPresented
        self._id = id
        self._title = title
        self._date = date
        self.done = done
        self.delete = delete
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("title", text: $title)
                }
                Section {
                    DatePicker("date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
                if id != emptyId {
                    Section {
                        Button("delete", role: .destructive) {
                            delete()
                        }
                    }
                }
            }
            .navigationTitle("record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done") {
                        done()
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(isPresented: .constant(true), id: .constant(emptyId), title: .constant(""), date: .constant(Date.now), done: {}, delete: {})
    }
}
