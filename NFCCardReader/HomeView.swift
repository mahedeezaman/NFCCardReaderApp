//
//  HomeView.swift
//  NFCCardReader
//
//  Created by Kobiraj on 2024-10-03.
//

import SwiftUI

struct HomeView: View {
    struct TabBarButtonIconView: View {
        @State var title = ""
        @State var logo = ""
        @Binding var currentlySelectedTab: Int
        @State var tabIndex = 0
        var body: some View {
            Button {
                currentlySelectedTab = tabIndex
            } label: {
                GeometryReader {px in
                    VStack(alignment: .center) {
                        Image(systemName: logo)
                            .resizable()
                            .foregroundColor(currentlySelectedTab == tabIndex ? Color.blue : Color.gray)
                            .frame(width: 28, height: 24)
                        Text(title)
                            .foregroundColor(currentlySelectedTab == tabIndex ? Color.blue : Color.gray)
                    }
                    .frame(width: px.size.width)
                }
                .frame(height: 50)
            }
        }
    }
    
    @State var selectedTab = 0
    var body: some View {
        GeometryReader { gr in
            VStack(spacing: 0) {
                VStack {
                    if selectedTab == 0 {
                        ZStack {
                            Color.gray.ignoresSafeArea()
                            ReaderView()
                        }
                    } else if selectedTab == 1 {
                        ScrollView{}
                    }
                }
                HStack {
                    TabBarButtonIconView(title: "Reader", logo: "book.fill", currentlySelectedTab: $selectedTab, tabIndex: 0)
                    TabBarButtonIconView(title: "Writer", logo: "pencil.circle.fill", currentlySelectedTab: $selectedTab, tabIndex: 1)
                }
                .padding(10)
                .background (
                    Color.white
                        .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 0)
                        .mask(Rectangle().padding(.top, -20))
                )
            }
            .ignoresSafeArea(.keyboard)
            .frame(width: gr.size.width, height: gr.size.height)
        }
    }
}

#Preview {
    HomeView(selectedTab: 0)
}
