//
//  OTPView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.08.23.
//

// https://github.com/kenagt/OtpView-SwiftUI/blob/master/Sources/OtpView-SwiftUI/OtpView_SwiftUI.swift

import SwiftUI
import Combine

public struct OTPView: View {
    
    // MARK: Fields
    enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var focusedField: FocusField?
    @Binding var code: String
    
    // MARK: Constructor
    public init(code: Binding<String>) {
        self._code = code
    }
    
    // MARK: Body
    public var body: some View {
        ZStack(alignment: .center) {
            TextField("", text: $code)
                .frame(width: 0, height: 0, alignment: .center)
                .font(Font.system(size: 0))
                .accentColor(.clear)
                .foregroundColor(.clear)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .onReceive(Just(code)) { _ in limitText(6) }
                .focused($focusedField, equals: .field)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                    {
                        self.focusedField = .field
                    }
                }
                .padding()
            
            HStack {
                ForEach(0 ..< 6) { index in
                    ZStack {
                        Text(self.getPin(at: index))
                            .font(.title)
                            .foregroundColor(.black)
                        
                        Rectangle()
                            .frame(height: 2)
                            .padding(.vertical, 20)
                            .foregroundColor(.black05)
                            .padding(.trailing, 5)
                            .padding(.leading, 5)
                            .opacity(self.code.count <= index ? 1 : 0)
                    }
                }
            }
        }
        .frame(height: 50)
    }
    
    // MARK: Heleprs
    
    private func getPin(at index: Int) -> String {
        guard self.code.count > index else {
            return ""
        }
        return self.code[index]
    }
    
    private func limitText(_ upper: Int) {
        if code.count > upper {
            code = String(code.prefix(upper))
        }
    }
}

extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
}
