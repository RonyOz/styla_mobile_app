import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_state.dart';

class _MeasureSelector extends StatelessWidget {

  final String title;
  final String subtitle;
  final List<int> values;
  final int initialValue;
  final ValueChanged<int> onValueChanged;

  const _MeasureSelector({
    required this.title,
    required this.subtitle,
    required this.values,
    required this.initialValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final initialIndex = values.indexOf(initialValue);
    const double itemWidth = 50.0; 
    
    final scrollController = ScrollController(
      initialScrollOffset: initialIndex * itemWidth - MediaQuery.of(context).size.width / 2 + itemWidth / 2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18), textAlign: TextAlign.center),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              initialValue.toString(),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Text(
              subtitle,
              style: TextStyle(color: AppColors.textPrimary.withOpacity(0.6), fontSize: 14),
            ),
          ],
        ),

        const Center(
          child: Icon(Icons.arrow_upward_sharp, color: AppColors.primary, size: 20),
        ),
        
        const SizedBox(height: 10),

        SizedBox(
          height: 80,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                final centerOffset = scrollController.offset + MediaQuery.of(context).size.width / 2;
                final index = (centerOffset / itemWidth).round();
                
                final newIndex = index.clamp(0, values.length - 1);

                scrollController.animateTo(
                  newIndex * itemWidth - MediaQuery.of(context).size.width / 2 + itemWidth / 2,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
                );
                onValueChanged(values[newIndex]);
              }
              return true;
            },
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemExtent: itemWidth, 
              itemCount: values.length,
              itemBuilder: (context, index) {
                final value = values[index];
                final isCenterValue = value == initialValue;
                
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (index % 5 == 0)
                        Text(
                          value.toString(),
                          style: TextStyle(
                            color: isCenterValue ? AppColors.textPrimary : AppColors.textPrimary.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      
                      const SizedBox(height: 5),

                      Container(
                        width: 2,
                        height: isCenterValue ? 20 : 10,
                        color: isCenterValue ? AppColors.primary : AppColors.white.withOpacity(0.4),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }
}

class OnboardingStepMeasurements extends StatelessWidget {

  static const int minAge = 18;
  static const int maxAge = 60;
  static const int minHeight = 150;
  static const int maxHeight = 200;
  static const int minWeight = 40;
  static const int maxWeight = 120;

  List<int> _generateValues(int min, int max) {
    return List<int>.generate(max - min + 1, (i) => min + i);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final currentAge = state.data.age > 0 ? state.data.age : 25;
        final currentHeight = state.data.height != null && state.data.height! > 0 ? state.data.height!.toInt() : 175;
        final currentWeight = state.data.weight != null && state.data.weight! > 0 ? state.data.weight!.toInt() : 75;

        if (state.data.age == 0) {
           WidgetsBinding.instance.addPostFrameCallback((_) {
             context.read<OnboardingBloc>().add(
               MeasurementsUpdated(age: currentAge, height: currentHeight.toDouble(), weight: currentWeight.toDouble()),
             );
           });
        }
        
        final isReadyToProceed = currentAge > minAge && currentHeight > minHeight && currentWeight > minWeight;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: state.currentPage > 0 
                      ? () => context.read<OnboardingBloc>().add(PreviousPageRequested())
                      : null,
                  icon: Icon(Icons.arrow_back_ios, size: 16, color: state.currentPage > 0 ? AppColors.textPrimary : AppColors.textPrimary.withOpacity(0.4)),
                  label: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 16,
                      color: state.currentPage > 0 ? AppColors.textPrimary : AppColors.textPrimary.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 6),
              
              const Text(
                'Descubre formas prácticas de vestir, recibe sugerencias de combinaciones y logra un estilo personal auténtico con Styla',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 10),

              _MeasureSelector(
                title: '¿Cuántos años tienes?',
                subtitle: '',
                values: _generateValues(minAge, maxAge),
                initialValue: currentAge,
                onValueChanged: (age) {
                  context.read<OnboardingBloc>().add(
                    MeasurementsUpdated(age: age, height: currentHeight.toDouble(), weight: currentWeight.toDouble()),
                  );
                },
              ),
              
              const SizedBox(height: 6), 

              _MeasureSelector(
                title: '¿Cuánto mides?',
                subtitle: 'cm',
                values: _generateValues(minHeight, maxHeight),
                initialValue: currentHeight,
                onValueChanged: (height) {
                  context.read<OnboardingBloc>().add(
                    MeasurementsUpdated(age: currentAge, height: height.toDouble(), weight: currentWeight.toDouble()),
                  );
                },
              ),
              
              const SizedBox(height: 6),

              _MeasureSelector(
                title: '¿Cuánto pesas?',
                subtitle: 'Kg',
                values: _generateValues(minWeight, maxWeight),
                initialValue: currentWeight,
                onValueChanged: (weight) {
                  context.read<OnboardingBloc>().add(
                    MeasurementsUpdated(age: currentAge, height: currentHeight.toDouble(), weight: weight.toDouble()),
                  );
                },
              ),
              
              const SizedBox(height: 10),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: isReadyToProceed 
                      ? () => context.read<OnboardingBloc>().add(NextPageRequested())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: isReadyToProceed 
                        ? const BorderSide(color: AppColors.primary, width: 2) 
                        : BorderSide.none,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Siguiente',
                        style: TextStyle(fontSize: 18, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, size: 16, color: isReadyToProceed ? AppColors.primary : Colors.white54),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 150), 
            ],
          ),
        );
      },
    );
  }
}