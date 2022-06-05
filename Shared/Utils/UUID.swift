//
//  UUID.swift
//  ShiBei
//
//  Created by Xie Zhihao on 2022/6/5.
//

import Foundation

extension UUID {
    static var empty: UUID {
        UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
}
