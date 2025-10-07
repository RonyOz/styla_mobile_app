# 📱 Carpeta App - Estructura de Navegación y Presentación

## 📋 Descripción

Esta carpeta contiene la configuración de la aplicación, navegación, páginas principales y layouts compartidos. Representa la **capa de presentación** en Clean Architecture.

## 📁 Estructura

```
lib/app/
├── app.dart                    # Widget raíz de la aplicación
├── routes/
│   ├── app_routes.dart        # Constantes de nombres de rutas
│   └── app_router.dart        # Configuración del sistema de navegación
├── pages/
│   ├── splash_page.dart       # Pantalla de splash inicial
│   └── home_page.dart         # Página principal/dashboard
└── layouts/
    └── main_layout.dart       # Layout base reutilizable (Scaffold)
```

## 🎯 Responsabilidades

### `app.dart`
- Configura el `MaterialApp`
- Define el tema global de la aplicación
- Establece la ruta inicial y configuración de rutas

### `routes/`
- **`app_routes.dart`**: Define todas las rutas como constantes (type-safe)
- **`app_router.dart`**: Mapea rutas a widgets, usa el sistema de navegación básico de Flutter

### `pages/`
Contiene las páginas principales de la aplicación:
- **`splash_page.dart`**: Primera pantalla, inicialización y verificación de auth
- **`home_page.dart`**: Dashboard principal después del login

### `layouts/`
- **`main_layout.dart`**: Scaffold reutilizable con AppBar, Drawer, BottomNavigationBar opcionales

## 🚀 Uso

### Navegación básica

```dart
// Navegar a una página
Navigator.pushNamed(context, AppRoutes.home);

// Reemplazar la ruta actual
Navigator.pushReplacementNamed(context, AppRoutes.login);

// Volver atrás
Navigator.pop(context);
```

### Agregar nuevas rutas

1. **Agregar constante en `app_routes.dart`**:
```dart
static const String myNewPage = '/my-new-page';
```

2. **Registrar ruta en `app_router.dart`**:
```dart
static Map<String, WidgetBuilder> get routes {
  return {
    // ... rutas existentes
    AppRoutes.myNewPage: (context) => const MyNewPage(),
  };
}
```

3. **Crear la página en `pages/`** o en tu feature correspondiente

## 🏗️ Clean Architecture

Esta carpeta sigue los principios de Clean Architecture:

- ✅ **Separación de responsabilidades**: Solo maneja UI y navegación
- ✅ **Independencia del framework**: Las features no dependen de esta capa
- ✅ **Flujo de dependencias**: app → features → core (hacia adentro)
- ✅ **Facilita testing**: Rutas y navegación aisladas y testeables

## 📝 TODOs

- [ ] Conectar rutas de autenticación (`/login`, `/register`)
- [ ] Conectar rutas de perfil (`/profile`, `/profile/edit`)
- [ ] Implementar lógica de verificación de auth en `splash_page.dart`
- [ ] Agregar manejo de deep links (opcional)
- [ ] Implementar navegación con parámetros usando `onGenerateRoute`

## 🔗 Integración con Features

Las páginas de features (auth, profile, etc.) deben registrarse aquí:

```dart
// En app_router.dart
import '../../features/auth/presentation/pages/login_page.dart';

static Map<String, WidgetBuilder> get routes {
  return {
    AppRoutes.login: (context) => const LoginPage(),
    // ...
  };
}
```
