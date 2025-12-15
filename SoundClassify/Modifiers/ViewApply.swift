//
//  ViewApply.swift
//  SnoreDetect
//
//  Created by Nguyen Hoang Tam on 15/12/25.
//


import SwiftUI

public extension View {
    func modify<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }
}
