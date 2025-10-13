import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/domain/model/preferences.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:styla_mobile_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  OnboardingBloc(this._completeOnboardingUseCase)
    : super(
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
      final prefs = state.preferences;
      emit(
        state.copyWith(
          preferences: state.preferences.copyWith(name: event.style + " "),
        ),
      );
    });

    on<AdditionalInfoUpdated>((event, emit) {
      final prefs = state.preferences;
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
  }
}
