//
//  UIView+UIViewRepresentable.swift
//  One Rep Max
//
//  Created by Nick Hayward on 3/23/21.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available (iOS 13, *)
extension UIView {
    private struct Preview: UIViewRepresentable {
        let view: UIView
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
        
        func makeUIView(context: Context) -> some UIView {
            let sizedView = view
            sizedView.setContentHuggingPriority(.required, for: .horizontal)
            sizedView.setContentHuggingPriority(.required, for: .vertical)
            return sizedView
        }
    }
    
    func toPreview() -> some View {
        Preview(view: self)
    }
}

#endif
