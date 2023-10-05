//
//  InAppMessages+Views.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 25.07.23.
//

import SwiftUI

private struct AlertImageView<Content> : View where Content : View {
    let hex: String
    let alignment: Alignment
    
    @ViewBuilder let content: (Color) -> Content
    
    var body: some View {
        let color = Color(hex: hex)
        return ZStack(alignment: alignment) {
            Rectangle()
                .fill(color)
                .opacity(0.24)
                .frame(width: 40, height: 40)
            content(color)
        }
        .cornerRadius(10)
    }
}

struct PopupTypeView<Content> : View where Content : View {
    let title: String
    var detail: String = ""
    @Binding var isShowing: Bool
    @ViewBuilder let icon: () -> Content

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "F7F7F9"))

            HStack {
                icon()
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "000000"))
                    Text(detail)
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "000000"))
                        .opacity(0.4)
                }
            }
            .padding()
        }
        .padding(.horizontal, 20)
        .contentShape(Rectangle())
        .onTapGesture {
            isShowing.toggle()
        }
    }
}

struct SectionHeader: View {
    let name: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("\(count)")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .opacity(0.8)
                
                Text("types")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .opacity(0.5)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ToastImage: View {
    let position: Position
    
    var body: some View {
        AlertImageView(hex: "87B9FF", alignment: position.toAligment()) { color in
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 40, height: 24)
                .padding(
                    EdgeInsets(
                        top: position == .top ? -16 : 0,
                        leading: 0,
                        bottom: position == .bottom ? -16 : 0,
                        trailing: 0
                    )
                )
        }
    }
    
    enum Position {
        case top, bottom
        
        func toAligment() -> Alignment {
            switch self {
            case .top:
                return .top
            case .bottom:
                return .bottom
            }
        }
    }
}

struct PopupImage: View {
    let style: Style
    
    var body: some View {
        AlertImageView(hex: "9265F8", alignment: style.toAligment()) { color in
            switch style {
            case .default:
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: 24, height: 20)
                
            case .bottom:
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: 24, height: 20)
                    .padding(.bottom, 4)
            }
        }
    }
    
    enum Style {
        case `default`
        case bottom
        
        func toAligment() -> Alignment {
            switch self {
            case .default:
                return .center
            case .bottom:
                return .bottom
            }
        }
    }
}

struct ToastView: View {

    var body: some View {
        Text("The toast view")
            .frame(width: 300, height: 60)
            .background(Color(hex: "87B9FF"))
            .cornerRadius(30.0)
    }
}
