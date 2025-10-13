// onboarding_layout.dart
import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

class OnboardingLayout extends StatelessWidget {
  const OnboardingLayout({
    super.key,
    required this.headline,
    this.body,
    required this.currentStep,
    required this.totalSteps,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    required this.onSkip,
    this.showSkip = true,
    required this.backgroundAsset,
    this.overlayColor,
  });

  final String headline;
  final String? body;
  final int currentStep;
  final int totalSteps;
  final String primaryActionLabel;
  final Future<void> Function() onPrimaryAction;
  final Future<void> Function() onSkip;
  final bool showSkip;

  final String backgroundAsset;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgroundAsset, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (overlayColor ?? Colors.black.withOpacity(0.22)),
                    Colors.transparent,
                    (overlayColor ?? Colors.black.withOpacity(0.35)),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // Foreground
          SafeArea(
            child: Stack(
              children: [
                // Skip in top-right with some margin
                if (showSkip)
                  Positioned(
                    top: AppSpacing.medium,
                    right: AppSpacing.large,
                    child: TextButton.icon(
                      onPressed: () => onSkip(),
                      label: const Text('Omitir'),
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: AppTypography.button.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),

                // Center content
                Column(
                  children: [
                    const Spacer(flex: 3),

                    // FULL-WIDTH CARD
                    Container(
                      width: double.infinity, // full width of SafeArea
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.large,
                        vertical: AppSpacing.large,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLightest,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withValues(alpha: 0.18),
                            offset: const Offset(0, 18),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            headline,
                            textAlign: TextAlign.center,
                            style: AppTypography.title.copyWith(
                              color: AppColors.textOnSecondary,
                              height: 1.3,
                            ),
                          ),
                          if (body != null && body!.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.medium),
                            Text(
                              body!,
                              textAlign: TextAlign.center,
                              style: AppTypography.body.copyWith(
                                color: AppColors.textOnSecondary,
                                height: 1.45,
                              ),
                            ),
                          ],

                          // PROGRESS BAR INSIDE THE CARD
                          const SizedBox(height: AppSpacing.medium),
                          Center(
                            child: _ProgressIndicator(
                              activeColor: AppColors.secondary,
                              inactiveColor: AppColors.secondaryLight,
                              current: currentStep,
                              total: totalSteps,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 4),
                  ],
                ),

                // Compact floating CTA bottom-right
                Positioned(
                  right: AppSpacing.large,
                  bottom: AppSpacing.large,
                  child: IntrinsicWidth(
                    child: AppButton.primary(
                      text: primaryActionLabel,
                      onPressed: () => onPrimaryAction(),
                      
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.current,
    required this.total,
    required this.activeColor,
    required this.inactiveColor,
  }) : assert(total > 0);

  final int current; // can be 0-based or 1-based; we normalize below
  final int total;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    // Normalize: if someone passes 1..total, convert to 0..total-1
    final bool looksOneBased = current >= 1 && current <= total;
    final int normalized = looksOneBased ? current - 1 : current;

    // Clamp to safe range
    final int safeIndex = normalized.clamp(0, total - 1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == safeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: isActive ? 36 : 16,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
