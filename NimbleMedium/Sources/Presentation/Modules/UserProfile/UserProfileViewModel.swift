//
//  UserProfileViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 04/10/2021.
//

import Resolver
import RxCocoa
import RxSwift

protocol UserProfileViewModelInput {

    func getUserProfile()
}

protocol UserProfileViewModelOutput {

    var userProfileUIModel: Driver<UserProfileView.UIModel?> { get }
    var errorMessage: Signal<String> { get }
}

protocol UserProfileViewModelProtocol: ObservableViewModel {

    var input: UserProfileViewModelInput { get }
    var output: UserProfileViewModelOutput { get }
}

final class UserProfileViewModel: ObservableObject, UserProfileViewModelProtocol {

    private let disposeBag = DisposeBag()
    private let getUserProfileTrigger = PublishRelay<String>()
    private let username: String?

    var input: UserProfileViewModelInput { self }
    var output: UserProfileViewModelOutput { self }

    @PublishRelayProperty var didGetUserProfile: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>

    @BehaviorRelayProperty(nil) var userProfileUIModel: Driver<UserProfileView.UIModel?>

    @Injected var getUserProfileUseCase: GetUserProfileUseCaseProtocol

    init(username: String?) {
        self.username = username
        
        getUserProfileTrigger
            .withUnretained(self)
            .flatMapLatest { owner, input in owner.getUserProfileTrigger(owner: owner, username: input) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension UserProfileViewModel: UserProfileViewModelInput {

    func getUserProfile() {
        if let username = username {
            getUserProfileTrigger.accept(username)
        } else {
            // TODO: Handle loading current user profile in integrate task
        }
    }
}

extension UserProfileViewModel: UserProfileViewModelOutput { }

private extension UserProfileViewModel {

    func getUserProfileTrigger(owner: UserProfileViewModel, username: String) -> Observable<Void> {
        getUserProfileUseCase
            .execute(username: username)
            .do(
                onSuccess: {
                    owner.$userProfileUIModel.accept(owner.generateUIModel(from: $0))
                },
                onError: { error in owner.$errorMessage.accept(error.detail) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    func generateUIModel(from profile: Profile) -> UserProfileView.UIModel {
        var username = Localizable.defaultUsernameValue()
        if !profile.username.isEmpty {
            username = profile.username
        }
        return UserProfileView.UIModel(
            avatarURL: try? profile.image?.asURL(),
            username: username
        )
    }
}
