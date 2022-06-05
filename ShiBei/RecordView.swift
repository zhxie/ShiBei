//
//  RecordView.swift
//  ShiBei
//
//  Created by Xie Zhihao on 2022/6/4.
//

import SwiftUI

struct RecordView: View {
    let title: String
    let date: Date
    let pin: Bool
    let recommended: Bool
    let callback: () -> Void
    
    var body: some View {
        Button {
            callback()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.background)
                
                HStack {
                    VStack (alignment: .leading, spacing: 4) {
                        Text(title + " ")
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        
                        HStack (spacing: 4) {
                            if pin {
                                Image(systemName: "pin.fill")
                                    .foregroundColor(.red)
                            }
                            else if recommended {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                            
                            Text(since)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    Text(String(count))
                        .font(.system(size: 48))
                        .layoutPriority(1)
                        .lineLimit(1)
                }
                .padding()
            }
            .foregroundColor(Color(UIColor.label))
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    var since: String {
        return String(format: "from_%@".localizedString, date.formatted(.dateTime.year().month().day()))
    }
    
    var count: Int {
        let dayToNow = date.dayToNow
        if dayToNow < 0 {
            return 0
        }
        
        return dayToNow + 1
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(title: "Today", date: Date.now, pin: true, recommended: true) {}
    }
}
