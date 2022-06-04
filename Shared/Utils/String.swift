//
//  String.swift
//  ShiBei
//
//  Created by Xie Zhihao on 2022/6/4.
//

import Foundation

extension String {
    var localizedString: String {
        NSLocalizedString(self, comment: "")
    }
}
