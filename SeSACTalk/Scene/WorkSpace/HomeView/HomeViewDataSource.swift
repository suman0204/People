//
//  HomeViewDataSource.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/20.
//

import UIKit
import RxSwift
import RxDataSources

enum SectionModel {
    case channelSection(header: UIView, items: [SectionItem], footer: UIView)
    case dmSection(header: UIView, items: [SectionItem], footer: UIView)
    case addMemberSection(header: UIView)
}

enum SectionItem {
    case channelItem(Channel)
    case dmItem(DM)
    case addMemberItem
}

extension SectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .channelSection(header: _, items: let items, footer: _):
            return items.map { $0 }
        case .dmSection(header: _, items: let items, footer: _):
            return items.map { $0 }
        case .addMemberSection(_):
            return []
        }
    }
    
    init(original: SectionModel, items: [Item]) {
        switch original {
        case let .channelSection(header: header, items: _, footer: footer):
            self = .channelSection(header: header, items: items, footer: footer)
        case let .dmSection(header: header, items: _, footer: footer):
            self = .dmSection(header: header, items: items, footer: footer)
        case let .addMemberSection(header: header):
            self = .addMemberSection(header: header)
        }
    }
}

extension SectionModel {
    var header: UIView {
        switch self {
        case .channelSection(let header, _, _):
            return header
        case .dmSection(let header, _, _):
            return header
        case .addMemberSection(let header):
            return header
        }
    }
}
