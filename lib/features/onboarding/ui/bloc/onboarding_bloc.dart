import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/domain/model/preferences.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:styla_mobile_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:styla_mobile_app/features/onboarding/domain/usecases/get_available_colors_usecase.dart';
import 'package:styla_mobile_app/features/onboarding/domain/usecases/get_available_styles_usecase.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CompleteOnboardingUseCase _completeOnboardingUseCase;
  final GetAvailableColorsUsecase _getAvailableColorsUsecase;
  final GetAvailableStylesUsecase _getAvailableStylesUsecase;

  OnboardingBloc(
    this._completeOnboardingUseCase,
    this._getAvailableColorsUsecase,
    this._getAvailableStylesUsecase,
  ) : super(
        OnboardingState(
          data: Profile.empty(),
          preferences: Preferences.empty(),
        ),
      ) {
    on<NextPageRequested>((event, emit) {
      if (state.currentPage < 4) {
        emit(state.copyWith(currentPage: state.currentPage + 1));
      }
    });

    on<PreviousPageRequested>((event, emit) {
      if (state.currentPage > 0) {
        emit(state.copyWith(currentPage: state.currentPage - 1));
      }
    });

    on<GenderSelected>(
      (event, emit) =>
          emit(state.copyWith(data: state.data.copyWith(gender: event.gender))),
    );

    on<MeasurementsUpdated>(
      (event, emit) => emit(
        state.copyWith(
          data: state.data.copyWith(
            age: event.age,
            height: event.height,
            weight: event.weight,
          ),
        ),
      ),
    );

    on<StyleSelected>((event, emit) {
      emit(
        state.copyWith(
          preferences: state.preferences.copyWith(name: event.style),
        ),
      );
    });

    on<AdditionalInfoUpdated>((event, emit) {
      emit(
        state.copyWith(
          preferences: state.preferences.copyWith(
            name: event.color + ' ' + event.imagePreference,
          ),
        ),
      );
    });

    on<ProfileInfoUpdated>(
      (event, emit) => emit(
        state.copyWith(
          data: state.data.copyWith(
            nickname: event.nickname,
            phoneNumber: event.phoneNumber,
          ),
        ),
      ),
    );

    on<SubmitOnboarding>((event, emit) async {
      emit(state.copyWith(status: OnboardingStatus.loading));
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId == null) {
          throw Exception('User is not authenticated.');
        }
        await _completeOnboardingUseCase.execute(
          userId,
          state.data,
          state.preferences,
        );
        emit(state.copyWith(status: OnboardingStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: OnboardingStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<LoadColorsRequested>((event, emit) async {
      try {
        final colors = await _getAvailableColorsUsecase.execute();
        emit(state.copyWith(availableColors: colors));
      } catch (e) {
        emit(
          state.copyWith(
            status: OnboardingStatus.failure,
            errorMessage: 'Error loading colors: $e',
          ),
        );
      }
    });

    on<LoadStylesRequested>((event, emit) async {
      try {
        final styles = await _getAvailableStylesUsecase.execute();
        emit(state.copyWith(availableStyles: styles));
      } catch (e) {
        emit(
          state.copyWith(
            status: OnboardingStatus.failure,
            errorMessage: 'Error loading styles: $e',
          ),
        );
      }
    });
  }
}
