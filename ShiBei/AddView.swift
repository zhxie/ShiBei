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
    @Binding var pin: Bool
    let done: () -> Void
    let delete: () -> Void

    init(isPresented: Binding<Bool>, id: Binding<UUID>, title: Binding<String>, date: Binding<Date>, pin: Binding<Bool>, done: @escaping () -> Void, delete: @escaping () -> Void) {
        UITableView.appearance().sectionFooterHeight = 0
        self._isPresented = isPresented
        self._id = id
        self._title = title
        self._date = date
        self._pin = pin
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
                Section {
                    Toggle(isOn: $pin) {
                        Label {
                            Text("pin")
                        } icon: {
                            ZStack {
                                Image(systemName: "pin.fill")
                                    .background(RoundedRectangle(cornerRadius: 7)
                                        .frame(width: 28, height: 28)
                                        .foregroundColor(.red)
                                    )
                                    .foregroundStyle(.white)
                            }
                        }

                    }
                }
#if false
                Section {
                    Toggle(isOn: $pin) {
                        Label {
                            Text("notification")
                        } icon: {
                            ZStack {
                                Image(systemName: "bell.badge.fill")
                                    .background(RoundedRectangle(cornerRadius: 7)
                                        .frame(width: 28, height: 28)
                                        .foregroundColor(.yellow)
                                    )
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    Toggle("each_hundredth_day", isOn: .constant(false))
                    Toggle("anniversary", isOn: .constant(false))
                    Toggle("monthiversary", isOn: .constant(false))
                }
#endif
                if id != UUID.empty {
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
                    Button("cancel", role: .cancel) {
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
        AddView(isPresented: .constant(true), id: .constant(UUID.empty), title: .constant(""), date: .constant(Date.now), pin: .constant(false), done: {}, delete: {})
    }
}
