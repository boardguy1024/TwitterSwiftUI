//
//  Timestamp+Extensions.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/18.
//

import Foundation
import Firebase

extension Timestamp {
    func timestampString() -> String {
        self.dateValue()
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1 // 時間の単位は1つに絞る (例：1h 30mではなく、1h)
        formatter.unitsStyle = .abbreviated // 表示スタイル例） 1h or 30m とか
        return formatter.string(from: self.dateValue(), to: Date()) ?? ""
    }
    
    func jpString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP") // 日本語のロケールを使用
        formatter.dateFormat = "a h:mm" // "午後 2:34"のフォーマットに合わせる
        return formatter.string(from: self.dateValue())
    }
}
