# Styla Mobile App

Aplicación móvil de asistente de estilo personal que ayuda a los usuarios a organizar su guardarropa, recibir recomendaciones diarias de outfits y explorar nuevas ideas de moda adaptadas a sus preferencias.

## Flujos Principales

#### 1. **Autenticación**
- **Welcome** - Pantalla de bienvenida con opciones de inicio de sesión/registro
- **Signin** - Inicio de sesión con email y contraseña
- **Signup** - Registro de nuevos usuarios con validación de email

#### 2. **Onboarding**
- Configuración inicial del perfil (después de la autenticación)
- **Gender** - Selección de género
- **Fill Profile** - Datos básicos del usuario
- **Measurements** - Medidas corporales
- **Style** - Preferencias de estilo
- **Additional Info** - Información adicional

#### 3. **Home**
- Dashboard principal con recomendaciones
- Navegación a funcionalidades principales

#### 4. **Profile**
- Gestión de perfil de usuario
- Configuración de preferencias
- Cerrar sesión

## Navegación entre Flujos

### Desde Welcome
- **"Iniciar sesión"** → Pantalla de Signin
- **"Registrarse"** → Pantalla de Signup

### Desde Signin
- **"Crear cuenta"** → Reemplaza con Signup
- **Botón atrás** → Vuelve a Welcome

### Desde Signup
- **"Iniciar sesión"** → Reemplaza con Signin
- **Botón atrás** → Vuelve a Welcome
- **Registro exitoso** → Navega a Onboarding

### Desde Onboarding
- **Completar proceso** → Navega a Home
- **Pasos**: Gender → Fill Profile → Measurements → Style → Additional Info

### Rutas Principales
```dart
AppRoutes.welcome    // /welcome
AppRoutes.login      // /login
AppRoutes.signup     // /signup
AppRoutes.onboarding // /onboarding (después de signup exitoso)
AppRoutes.home       // /home
AppRoutes.profile    // /profile
```

## Estructura del Código

```text
lib/
├── app/
│   ├── pages/          # Páginas generales (welcome)
│   └── routes/         # Configuración de rutas
├── core/
│   └── ui/
│       ├── design/     # Tokens de diseño (colors, typography, spacing)
│       ├── theme/      # Tema de la aplicación
│       └── widgets/    # Componentes reutilizables
└── features/
    ├── auth/           # Flujo de autenticación
    │   ├── data/       # Repositorios e implementaciones
    │   ├── domain/     # Casos de uso y entidades
    │   └── ui/
    │       ├── screens/    # Signin, Signup
    │       ├── widgets/    # AuthAppBar
    │       └── bloc/       # Lógica de estado
    ├── onboarding/     # Flujo de configuración inicial
    │   ├── data/       # Modelos y repositorios
    │   ├── domain/     # Entidades y casos de uso
    │   └── ui/
    │       ├── screens/    # Onboarding screen
    │       ├── widgets/    # Pasos del onboarding
    │       └── bloc/       # Lógica de estado
    └── profile/        # Gestión de perfil
        ├── data/       # Repositorios e implementaciones
        ├── domain/     # Casos de uso
        └── ui/
            ├── screens/    # Profile screen
            └── bloc/       # Lógica de estado
```