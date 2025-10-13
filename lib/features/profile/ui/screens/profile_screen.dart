import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:styla_mobile_app/features/profile/ui/bloc/events/profile_event.dart';
import 'package:styla_mobile_app/features/profile/ui/bloc/profile_bloc.dart';
import 'package:styla_mobile_app/features/profile/ui/bloc/states/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLogoutConfirmationVisible = false;

  @override
  void initState() {
    super.initState();
    // Le decimos al BLoC que cargue el perfil en cuanto la pantalla se inicie
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLogoutConfirmation) {
            // Cuando el BLoC nos lo indique, mostramos el widget de confirmación
            setState(() {
              _isLogoutConfirmationVisible = true;
            });
          }
          if (state is ProfileSignedOut) {
            // Si el cierre de sesión fue exitoso, navegamos al login
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Contenido principal de la pantalla
              if (state is ProfileLoading || state is ProfileInitial)
                const Center(child: CircularProgressIndicator()),
              if (state is ProfileLoaded)
                _buildProfileView(context, state.profile),
              if (state is ProfileError)
                 Center(child: Text(state.message, style: const TextStyle(color: Colors.white))),

              // Widget de confirmación (overlay)
              if (_isLogoutConfirmationVisible)
                _buildLogoutConfirmation(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, Profile profile) {
    return Column(
      children: [
        _buildHeader(context, profile),
        Expanded(child: _buildMenuList(context)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Profile profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFD8CCE8), // Tono púrpura claro de la imagen
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 16),
              label: const Text('My Profile', style: TextStyle(color: Colors.black, fontSize: 16)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(height: 10),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: profile.photo != null ? NetworkImage(profile.photo!) : null,
            child: profile.photo == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            profile.nickname,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 24),
          _buildStatsRow(profile),
        ],
      ),
    );
  }

  Widget _buildStatsRow(Profile profile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF7E57C2), // Tono púrpura más oscuro
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('${profile.weight?.toStringAsFixed(0) ?? '-'} Kg', 'Weight'),
          _statItem('${profile.age}', 'Years Old'),
          _statItem('${(profile.height != null ? profile.height! / 100 : 0).toStringAsFixed(2)} M', 'Height'),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
      ],
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        children: [
          _menuListItem(Icons.person_outline, 'Profile', () {}),
          const SizedBox(height: 12),
          _menuListItem(Icons.settings_outlined, 'Settings', () {}),
          const Spacer(),
          // Este botón ahora solo pide la confirmación
          _menuListItem(Icons.logout, 'Cerrar Sesión', () {
            context.read<ProfileBloc>().add(SignOutRequested());
          }, color: Colors.white),
        ],
      ),
    );
  }

  Widget _menuListItem(IconData icon, String title, VoidCallback onTap, {Color color = Colors.white}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLogoutConfirmation(BuildContext context) {
    return Container(
      color: Colors.black54, // Fondo semitransparente
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Color(0xFFEEFF41), // Tono amarillo/lima
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¿Estás seguro de que quieres cerrar sesión?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLogoutConfirmationVisible = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Este botón confirma la acción y se lo dice al BLoC
                      context.read<ProfileBloc>().add(SignOutConfirmed());
                    },
                     style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cerrar Sesión'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}