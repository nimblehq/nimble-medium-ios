//
//  EditProfileViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 13/10/2021.
//

import RxSwift
import RxCocoa
import Combine
import Resolver

// sourcery: AutoMockable
protocol EditProfileViewModelInput {

    func didTapUpdateButton(
        username: String,
        email: String,
        password: String,
        avatarURL: String,
        bio: String
    )
    func getCurrentUserProfile()
}

protocol EditProfileViewModelOutput {

    var didUpdateProfile: Signal<Void> { get }
    var editProfileUIModel: Driver<EditProfileView.UIModel> { get }
    var errorMessage: Signal<String> { get }
    var isLoading: Driver<Bool> { get }
}

protocol EditProfileViewModelProtocol: ObservableViewModel {

    var input: EditProfileViewModelInput { get }
    var output: EditProfileViewModelOutput { get }
}

final class EditProfileViewModel: ObservableObject, EditProfileViewModelProtocol {

    typealias UpdateCurrentUserParams = (
        username: String, email: String, password: String?, avatarURL: String, bio: String
    )
    
    private let disposeBag = DisposeBag()

    var input: EditProfileViewModelInput { self }
    var output: EditProfileViewModelOutput { self }

    @PublishRelayProperty var didUpdateProfile: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>

    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>
    @BehaviorRelayProperty(EditProfileView.UIModel()) var editProfileUIModel: Driver<EditProfileView.UIModel>

    @Injected var getCurrentUserUseCase: GetCurrentUserUseCaseProtocol
    @Injected var updateCurrentUserUseCase: UpdateCurrentUserUseCaseProtocol

    private let getCurrentUserTrigger = PublishRelay<Void>()
    private let updateCurrentUserSessionTrigger = PublishRelay<UpdateCurrentUserParams>()

    init() {
        getCurrentUserTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.getCurrentUserTriggered(owner: owner) }
            .subscribe()
            .disposed(by: disposeBag)
        
        updateCurrentUserSessionTrigger
            .withUnretained(self)
            .flatMapLatest { owner, inputs in owner.updateCurrentUserTriggered(owner: owner, inputs: inputs) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension EditProfileViewModel: EditProfileViewModelInput {

    func getCurrentUserProfile() {
        getCurrentUserTrigger.accept(())
    }

    func didTapUpdateButton(
        username: String,
        email: String,
        password: String,
        avatarURL: String,
        bio: String
    ) {
        $isLoading.accept(true)
        updateCurrentUserSessionTrigger.accept((username, email, password.toNilIfEmpty(), avatarURL, bio))
    }
}

extension EditProfileViewModel: EditProfileViewModelOutput { }

private extension EditProfileViewModel {

    func getCurrentUserTriggered(owner: EditProfileViewModel) -> Observable<Void> {
        getCurrentUserUseCase
            .execute()
            .do(
                onSuccess: { owner.$editProfileUIModel.accept(owner.generateUIModel(fromUser: $0)) },
                onError: { error in owner.$errorMessage.accept(error.detail) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    func updateCurrentUserTriggered(owner: EditProfileViewModel, inputs: UpdateCurrentUserParams) -> Observable<Void> {
        updateCurrentUserUseCase
            .execute(
                params: UpdateCurrentUserParameters(
                    username: inputs.username,
                    email: inputs.email,
                    password: inputs.password,
                    image: inputs.avatarURL,
                    bio: inputs.bio
                )
            )
            .do(
                onError: { error in
                    owner.$isLoading.accept(false)
                    owner.$errorMessage.accept(error.detail)
                },
                onCompleted: {
                    owner.$isLoading.accept(false)
                    owner.$didUpdateProfile.accept(())
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    func generateUIModel(fromUser user: User) -> EditProfileView.UIModel {
        return EditProfileView.UIModel(
            username: user.username,
            email: user.email,
            avatarURL: user.image ?? "",
            bio: user.bio ?? ""
        )
    }
}
