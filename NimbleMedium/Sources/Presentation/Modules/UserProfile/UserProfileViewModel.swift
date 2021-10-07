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
    private let getCurrentUserTrigger = PublishRelay<Void>()
    private let getOtherUserProfileTrigger = PublishRelay<String>()
    private let username: String?

    var input: UserProfileViewModelInput { self }
    var output: UserProfileViewModelOutput { self }

    @PublishRelayProperty var didGetUserProfile: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>

    @BehaviorRelayProperty(nil) var userProfileUIModel: Driver<UserProfileView.UIModel?>

    @Injected var getCurrentUserUseCase: GetCurrentUserUseCaseProtocol
    @Injected var getUserProfileUseCase: GetUserProfileUseCaseProtocol

    init(username: String?) {
        self.username = username

        getCurrentUserTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.getCurrentUserTriggered(owner: owner) }
            .subscribe()
            .disposed(by: disposeBag)
        
        getOtherUserProfileTrigger
            .withUnretained(self)
            .flatMapLatest { owner, input in owner.getOtherUserProfileTriggered(owner: owner, username: input) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension UserProfileViewModel: UserProfileViewModelInput {

    func getUserProfile() {
        if let username = username {
            getOtherUserProfileTrigger.accept(username)
        } else {
            getCurrentUserTrigger.accept(())
        }
    }
}

extension UserProfileViewModel: UserProfileViewModelOutput { }

private extension UserProfileViewModel {

    func getCurrentUserTriggered(owner: UserProfileViewModel) -> Observable<Void> {
        getCurrentUserUseCase
            .execute()
            .do(
                onSuccess: {
                    owner.$userProfileUIModel.accept(owner.generateUIModel(fromUser: $0))
                },
                onError: { error in
                    owner.$errorMessage.accept(error.detail)
                    owner.$userProfileUIModel.accept(nil)
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    func getOtherUserProfileTriggered(owner: UserProfileViewModel, username: String) -> Observable<Void> {
        getUserProfileUseCase
            .execute(username: username)
            .do(
                onSuccess: {
                    owner.$userProfileUIModel.accept(owner.generateUIModel(fromProfile: $0))
                },
                onError: { error in
                    owner.$errorMessage.accept(error.detail)
                    owner.$userProfileUIModel.accept(nil)
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    func generateUIModel(fromProfile profile: Profile) -> UserProfileView.UIModel {
        var username = Localizable.defaultUsernameValue()
        if !profile.username.isEmpty {
            username = profile.username
        }
        return UserProfileView.UIModel(
            avatarURL: try? profile.image?.asURL(),
            username: username
        )
    }

    func generateUIModel(fromUser user: User) -> UserProfileView.UIModel {
        var username = Localizable.defaultUsernameValue()
        if !user.username.isEmpty {
            username = user.username
        }
        return UserProfileView.UIModel(
            avatarURL: try? user.image?.asURL(),
            username: username
        )
    }
}
