import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maddy_notes/features/auth/presentation/login_screen.dart';
import 'package:maddy_notes/features/auth/providers/auth_provider.dart';
import 'package:maddy_notes/features/notes/presentation/notes_list_screen.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }
        return const NotesListScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Something went wrong')),
      ),
    );
  }
}
