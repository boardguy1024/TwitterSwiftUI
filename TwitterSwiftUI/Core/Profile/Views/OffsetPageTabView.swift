//
//  OffsetPageTabView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/10/12.
//

import SwiftUI

struct OffsetPageTabView<Content: View>: UIViewRepresentable {
    
    var content: Content
    @Binding var offset: CGFloat
    @Binding var isScrolling: Bool
    
    init(offset: Binding<CGFloat>, isScrolling: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._offset = offset
        self._isScrolling = isScrolling
        self.content = content()
    }
    
    func makeCoordinator() -> Coordinator  {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> some UIScrollView {
        let scrollView = UIScrollView()
        
        // Content(SwiftUI) 呼び出し先の { } から受け取ったViewを scrollViewに貼り付ける
        let hostView = UIHostingController(rootView: content)
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ]
        
        scrollView.addSubview(hostView.view)
        scrollView.addConstraints(constraints)
        
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateUIView(_ uiView: some UIScrollView, context: Context) {
                
        let currentOffset = uiView.contentOffset.x
        
        // 外部から offset値が変更された場合
        if currentOffset != offset {
            uiView.setContentOffset(.init(x: offset, y: 0), animated: true)
        }
    }
}

extension OffsetPageTabView {
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var parent: OffsetPageTabView
        
        init(parent: OffsetPageTabView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
            parent.isScrolling = (scrollView.isDragging || scrollView.isTracking || scrollView.isDecelerating)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            parent.isScrolling = false
        }

    }
}
