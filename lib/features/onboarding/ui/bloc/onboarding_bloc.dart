import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/domain/entitites/onboarding_data.dart';
import 'package:styla_mobile_app/features/onboarding/domain/entitites/user_preferences.dart';
import 'package:styla_mobile_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  OnboardingBloc(this._completeOnboardingUseCase)
      : super(OnboardingState(data: OnboardingData())) {
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

    on<GenderSelected>((event, emit) =>
        emit(state.copyWith(data: state.data.copyWith(gender: event.gender))));

    on<MeasurementsUpdated>((event, emit) => emit(state.copyWith(
        data: state.data.copyWith(
            age: event.age, height: event.height, weight: event.weight))));
    
    on<StyleSelected>((event, emit) {
      final prefs = state.data.preferences ?? UserPreferences(style: '', preferredColor: '', preferredImage: '');
      emit(state.copyWith(data: state.data.copyWith(preferences: UserPreferences(style: event.style, preferredColor: prefs.preferredColor, preferredImage: prefs.preferredImage))));
    });

    on<AdditionalInfoUpdated>((event, emit) {
      final prefs = state.data.preferences ?? UserPreferences(style: '', preferredColor: '', preferredImage: '');
      emit(state.copyWith(data: state.data.copyWith(preferences: UserPreferences(style: prefs.style, preferredColor: event.color, preferredImage: event.imagePreference))));
    });

    on<ProfileInfoUpdated>((event, emit) => emit(state.copyWith(
        data: state.data.copyWith(
            fullName: event.fullName,
            nickname: event.nickname,
            phoneNumber: event.phoneNumber))));

    on<SubmitOnboarding>((event, emit) async {
      emit(state.copyWith(status: OnboardingStatus.loading));
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId == null) {
          throw Exception('User is not authenticated.');
        }
        await _completeOnboardingUseCase.execute(userId, state.data);
        emit(state.copyWith(status: OnboardingStatus.success));
      } catch (e) {
        emit(state.copyWith(
            status: OnboardingStatus.failure, errorMessage: e.toString()));
      }
    });
  }
}