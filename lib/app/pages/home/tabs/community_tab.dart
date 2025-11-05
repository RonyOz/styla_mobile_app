import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/community_bloc.dart';
import 'package:styla_mobile_app/features/community/ui/screens/feed_screen.dart';

/// Community tab - Social features, posts, and user interactions
class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityBloc(),
      child: const FeedScreen(),
    );
  }
}
