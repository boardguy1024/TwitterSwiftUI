//
//  PagerTabView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/10/12.
//

import SwiftUI

struct PagerTabView<Tab: View, Content: View>: View {
    
    struct TabItem: Identifiable {
        var id: Int
        var tabView: Tab
    }
    
    private var tabs: [TabItem]
    
    // Page Content
    private var content: Content
    
    @Binding var selectedTab: Int
    
    init(selected: Binding<Int>,
         tabs: [Tab],
         @ViewBuilder content: @escaping () -> Content) {
        _selectedTab = selected
        self.tabs = tabs.enumerated().map { index, tab in
            TabItem(id: index, tabView: tab)}
        self.content = content()
    }
    
    @State private var underlineViewOffset: CGFloat = 0
    @State private var isScrolling: Bool = false
    @State private var offset: CGFloat = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            tabLabelsView
            
            underlineView
            
            Divider()
            
            OffsetPageTabView(offset: $offset, isScrolling: $isScrolling) {
                HStack(spacing: 0) {
                    content
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .onChange(of: offset) { _ in
            // SwipeでPagingする時のみ、UnderlineViewを移動させる
            if isScrolling {
                underlineViewOffset = offset / 3
            }
        }
        .onChange(of: isScrolling) { _ in
            if isScrolling == false {
                selectedTab = Int((offset / screenWidth).rounded())
            }
        }
    }
    
    func getOpacity(currentTab: Int) -> CGFloat {
        
        let position = self.offset / screenWidth

        let progress = abs(CGFloat(currentTab) - position)
        
        // current=1 or other=0.6
        let opacity = 1 - (min(1, progress) * 0.4)
        return opacity
    }
}

extension PagerTabView {
    
    var tabLabelsView: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { item in
                item.tabView
                    .frame(maxWidth: .infinity)
                    .onTapGesture {

                        self.selectedTab = item.id
                        
                        let contentOffset = screenWidth * CGFloat(item.id)
                        // ボタンをタップした位置に PageViewをoffset
                        
                        withAnimation {
                            offset = contentOffset
                            // ボタンをタップした位置に UnderlineViewを位置させる
                            underlineViewOffset = contentOffset / 3
                        }
                    }
                    .opacity(getOpacity(currentTab: item.id))
            }
        }
    }

    var underlineView: some View {
        Capsule()
            .fill(Color(.systemBlue))
            .frame(width: 100, height: 5)
            .padding(.top, 2)
            .offset(x: -screenWidth / 3)
            .offset(x: underlineViewOffset)
    }
    
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
}
