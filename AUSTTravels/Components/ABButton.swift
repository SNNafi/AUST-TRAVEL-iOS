//
//  ABButton.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 1/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import Combine

struct ABButton: View {
    var text: String
    var textColor: Color
    var backgroundColor: Color
    var font: GenericFont.Font
    var action: () -> ()
    var icon: Icon? = nil
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 7.dWidth()).foregroundColor(backgroundColor)
                    .frame(width: dWidth * 0.9, height: 57.dHeight())
                    .padding(10.dHeight())
                    .padding(.horizontal, 15.dHeight())
                HStack {
                    if icon != nil {
                        icon
                    }
                    Text(text)
                        .scaledFont(font: font, dsize: 18)
                        .foregroundColor(textColor)
                }
            }
        }
    }
}

struct ABButton_Previews: PreviewProvider {
    static var previews: some View {
        ABButton(text: "", textColor: .white, backgroundColor: .black, font: .sairaCondensedRegular, action: {})
    }
}

extension ABButton {
    func rightIcon(_ icon: Icon) -> ABButton {
        var view = self
        view.icon = icon
        return view
    }
}


class FieldChecker<T : Hashable> : ObservableObject {
    
    internal var numberOfCheck = 0
    @Published public fileprivate(set) var errorMessage:String?
    
    internal var boundSub:AnyCancellable?
    fileprivate var subject = PassthroughSubject<T,Never>()
    
    public var isFirstCheck:Bool { numberOfCheck == 0 }
    
    public var valid:Bool {
        self.errorMessage == nil
    }
    
    public init( errorMessage:String? = nil ) {
        self.errorMessage = errorMessage
    }
    
    fileprivate func bind( to value:T, debounceInMills debounce:Int, andValidateWith validator:@escaping(T) -> String? ) {
        if boundSub == nil  {
            //            print( "bind( to: )")
            boundSub = subject.debounce(for: .milliseconds(debounce), scheduler: RunLoop.main)
                .sink {
                    //                            print( "validate: \($0)" )
                    self.errorMessage = validator( $0 )
                    self.numberOfCheck += 1
                    
                }
            // First Validation
            self.errorMessage = validator( value )
        }
    }
    
    fileprivate func doValidate( value newValue:T ) -> Void {
        self.subject.send(newValue)
        
    }
    
}

extension Binding where Value : Hashable {
    
    func onValidate( checker: FieldChecker<Value>, debounceInMills debounce: Int = 0, validator: @escaping (Value) -> String? ) -> Binding<Value> {
        
        DispatchQueue.main.async {
            checker.bind(to: self.wrappedValue, debounceInMills: debounce, andValidateWith: validator)
        }
        return Binding(
            get: { self.wrappedValue },
            set: { newValue in
                
                if( newValue != self.wrappedValue) {
                    checker.doValidate(value: newValue )
                }
                self.wrappedValue = newValue
            }
        )
    }
}


extension FieldChecker {

    public var errorMessageOrNilAtBeginning:String?  {
        self.isFirstCheck ? nil : errorMessage
    }
}

class FieldValidator<T> : ObservableObject where T : Hashable {
    public typealias Validator = (T) -> String?

    @Binding private var bindValue: T
    @Binding private var checker: FieldChecker<T>

    @Published public var value:T
    {
        willSet {
            if( newValue != value) {
                self.doValidate(value: newValue)
            }
        }
        didSet {
            self.bindValue = self.value
        }
    }
    private let validator: Validator

    public var isValid: Bool { self.checker.valid }

    public var errorMessage: String? { self.checker.errorMessage }

    public init( _ value: Binding<T>, checker: Binding<FieldChecker<T>>, validator: @escaping Validator  ) {
        self.validator = validator
        self._bindValue = value
        self.value = value.wrappedValue
        self._checker = checker
    }

    fileprivate func doValidate( value newValue: T ) -> Void {
        DispatchQueue.main.async {
            self.checker.errorMessage = self.validator( newValue )
            self.checker.numberOfCheck += 1
        }
    }

    public func doValidate() -> Void {
        DispatchQueue.main.async {
            self.checker.errorMessage = self.validator( self.value )
        }
    }

}


protocol ViewWithFieldValidator: View {
    var field:FieldValidator<String> {get}

}

extension ViewWithFieldValidator {

    internal func execIfValid( _ onCommit: @escaping () -> Void ) -> () -> Void {
        return {
            if( self.field.isValid ) {
                onCommit()
            }
        }
    }


}
