//
//  NewsDetail.swift
//  goodzik-ios
//
//  Created by Yehor Myropoltsev on 05.12.2024.
//

import APIClient
import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct NewsDetail: Reducer {
    @ObservableState
    public struct State: Equatable {
        var item: NewsItem
        
        public init(item: NewsItem) {
            self.item = item
        }
    }
    
    public enum Action: ViewAction {
        case delegate(Delegate)
        case `internal`(Internal)
        case view(View)
        
        public enum Delegate: Equatable {}
        public enum Internal: Equatable {}
        public enum View: Equatable, BindableAction {
            case binding(BindingAction<NewsDetail.State>)
            case onAppear
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce { _, action in
            switch action {
            case .delegate:
                return .none
                
            case .internal:
                return .none
                
            case .view(.binding):
                return .none
                
            case .view(.onAppear):
                return .none
            }
        }
    }
}
