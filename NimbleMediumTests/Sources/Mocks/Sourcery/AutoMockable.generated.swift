// Generated using Sourcery 1.5.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

@testable import NimbleMedium
import RxSwift
import RxCocoa















class LoginUseCaseProtocolMock: LoginUseCaseProtocol {

    //MARK: - login

    var loginEmailPasswordCallsCount = 0
    var loginEmailPasswordCalled: Bool {
        return loginEmailPasswordCallsCount > 0
    }
    var loginEmailPasswordReceivedArguments: (email: String, password: String)?
    var loginEmailPasswordReceivedInvocations: [(email: String, password: String)] = []
    var loginEmailPasswordReturnValue: Completable!
    var loginEmailPasswordClosure: ((String, String) -> Completable)?

    func login(email: String, password: String) -> Completable {
        loginEmailPasswordCallsCount += 1
        loginEmailPasswordReceivedArguments = (email: email, password: password)
        loginEmailPasswordReceivedInvocations.append((email: email, password: password))
        return loginEmailPasswordClosure.map({ $0(email, password) }) ?? loginEmailPasswordReturnValue
    }

}

class ModuleFactoryProtocolMock: ModuleFactoryProtocol {

    //MARK: - loginUseCase

    var loginUseCaseCallsCount = 0
    var loginUseCaseCalled: Bool {
        return loginUseCaseCallsCount > 0
    }
    var loginUseCaseReturnValue: LoginUseCaseProtocol!
    var loginUseCaseClosure: (() -> LoginUseCaseProtocol)?

    func loginUseCase() -> LoginUseCaseProtocol {
        loginUseCaseCallsCount += 1
        return loginUseCaseClosure.map({ $0() }) ?? loginUseCaseReturnValue
    }

    //MARK: - feedsViewModel

    var feedsViewModelCallsCount = 0
    var feedsViewModelCalled: Bool {
        return feedsViewModelCallsCount > 0
    }
    var feedsViewModelReturnValue: FeedsViewModelProtocol!
    var feedsViewModelClosure: (() -> FeedsViewModelProtocol)?

    func feedsViewModel() -> FeedsViewModelProtocol {
        feedsViewModelCallsCount += 1
        return feedsViewModelClosure.map({ $0() }) ?? feedsViewModelReturnValue
    }

    //MARK: - homeViewModel

    var homeViewModelCallsCount = 0
    var homeViewModelCalled: Bool {
        return homeViewModelCallsCount > 0
    }
    var homeViewModelReturnValue: HomeViewModelProtocol!
    var homeViewModelClosure: (() -> HomeViewModelProtocol)?

    func homeViewModel() -> HomeViewModelProtocol {
        homeViewModelCallsCount += 1
        return homeViewModelClosure.map({ $0() }) ?? homeViewModelReturnValue
    }

    //MARK: - loginViewModel

    var loginViewModelCallsCount = 0
    var loginViewModelCalled: Bool {
        return loginViewModelCallsCount > 0
    }
    var loginViewModelReturnValue: LoginViewModelProtocol!
    var loginViewModelClosure: (() -> LoginViewModelProtocol)?

    func loginViewModel() -> LoginViewModelProtocol {
        loginViewModelCallsCount += 1
        return loginViewModelClosure.map({ $0() }) ?? loginViewModelReturnValue
    }

    //MARK: - sideMenuActionsViewModel

    var sideMenuActionsViewModelCallsCount = 0
    var sideMenuActionsViewModelCalled: Bool {
        return sideMenuActionsViewModelCallsCount > 0
    }
    var sideMenuActionsViewModelReturnValue: SideMenuActionsViewModelProtocol!
    var sideMenuActionsViewModelClosure: (() -> SideMenuActionsViewModelProtocol)?

    func sideMenuActionsViewModel() -> SideMenuActionsViewModelProtocol {
        sideMenuActionsViewModelCallsCount += 1
        return sideMenuActionsViewModelClosure.map({ $0() }) ?? sideMenuActionsViewModelReturnValue
    }

    //MARK: - sideMenuViewModel

    var sideMenuViewModelCallsCount = 0
    var sideMenuViewModelCalled: Bool {
        return sideMenuViewModelCallsCount > 0
    }
    var sideMenuViewModelReturnValue: SideMenuViewModelProtocol!
    var sideMenuViewModelClosure: (() -> SideMenuViewModelProtocol)?

    func sideMenuViewModel() -> SideMenuViewModelProtocol {
        sideMenuViewModelCallsCount += 1
        return sideMenuViewModelClosure.map({ $0() }) ?? sideMenuViewModelReturnValue
    }

    //MARK: - signupViewModel

    var signupViewModelCallsCount = 0
    var signupViewModelCalled: Bool {
        return signupViewModelCallsCount > 0
    }
    var signupViewModelReturnValue: SignupViewModelProtocol!
    var signupViewModelClosure: (() -> SignupViewModelProtocol)?

    func signupViewModel() -> SignupViewModelProtocol {
        signupViewModelCallsCount += 1
        return signupViewModelClosure.map({ $0() }) ?? signupViewModelReturnValue
    }

}

