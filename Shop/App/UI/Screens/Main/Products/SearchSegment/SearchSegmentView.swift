//
//  SearchSegmentView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.07.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SearchSegmentView

struct SearchSegmentView {
    let store: StoreOf<SearchSegmentReducer>
    
    struct ViewState: Equatable {
        var segments: [Segment]
        @BindingViewState var selectedSegment: Segment
    }
}

// MARK: - Views

extension SearchSegmentView: View {
    
    var body: some View {
        content
    }

    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view) { viewStore in
            SearchSegmentControl(segments: viewStore.segments,
                                 selectedSegment: viewStore.$selectedSegment)
        }
    }
}


// MARK: BindingViewStore

extension BindingViewStore<SearchSegmentReducer.State> {
    var view: SearchSegmentView.ViewState {
        SearchSegmentView.ViewState(segments: self.segments,
                                    selectedSegment: self.$selectedSegment)
    }
}

// MARK: SearchSegmentControl

struct SearchSegmentControl: View {
    var segments: [Segment]
    @Binding var selectedSegment: Segment
    @State private var scrollToSegment = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollViewProxy in
                HStack(spacing: 16) {
                    ForEach(segments, id: \.self) { segment in
                        SearchSegmentItemView(segment: segment, isSelected: segment == selectedSegment)
                            .onTapGesture {
                                selectedSegment = segment
                                withAnimation {
                                    scrollToSegment = true
                                }
                            }
                            .id(segment)
                    }
                }
                .onChange(of: scrollToSegment) { value in
                    if value {
                        withAnimation {
                            scrollViewProxy.scrollTo(selectedSegment)
                            scrollToSegment = false
                        }
                    }
                }
            }
        }
    }
}

struct SearchSegmentItemView: View {
    let segment: Segment
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 0) {
            Text(segment.description)
                .font(.body)
                .padding(.vertical, 8)

            if isSelected {
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.black)
            } else {
                Color.clear
                    .frame(height: 2)
            }
        }
    }
}
