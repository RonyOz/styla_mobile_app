import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';
import 'package:styla_mobile_app/core/ui/design/app_colors.dart';
import 'package:styla_mobile_app/features/onboarding/data/repository/onboarding_repository_impl.dart';
import 'package:styla_mobile_app/features/onboarding/data/source/onboarding_data_source.dart';
import 'package:styla_mobile_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:styla_mobile_app/features/onboarding/domain/usecases/get_available_colors_usecase.dart';
import 'package:styla_mobile_app/features/onboarding/domain/usecases/get_available_styles_usecase.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_state.dart';
import 'package:styla_mobile_app/features/onboarding/ui/widgets/onboarding_step_additional_info.dart';
import 'package:styla_mobile_app/features/onboarding/ui/widgets/onboarding_step_fill_profile.dart';
import 'package:styla_mobile_app/features/onboarding/ui/widgets/onboarding_step_gender.dart';
import 'package:styla_mobile_app/features/onboarding/ui/widgets/onboarding_step_measurements.dart';
import 'package:styla_mobile_app/features/onboarding/ui/widgets/onboarding_step_style.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = OnboardingRepositoryImpl(OnboardingDataSourceImpl());

    return BlocProvider(
      create: (context) => OnboardingBloc(
        CompleteOnboardingUseCase(repository),
        GetAvailableColorsUsecase(repository: repository),
        GetAvailableStylesUsecase(repository: repository),
      ),
      child: OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = Supabase.instance.client.auth.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            _pageController.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );

            if (state.status == OnboardingStatus.success) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
            if (state.status == OnboardingStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                OnboardingStepGender(),
                OnboardingStepMeasurements(),
                OnboardingStepStyle(),
                OnboardingStepAdditionalInfo(),
                OnboardingStepFillProfile(userEmail: email),
              ],
            );
          },
        ),
      ),
    );
  }
}
