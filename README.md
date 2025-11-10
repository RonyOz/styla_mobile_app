# Styla Mobile App

Aplicación móvil de asistente de estilo personal que ayuda a los usuarios a organizar su guardarropa, recibir recomendaciones diarias de outfits, explorar nuevas ideas de moda y compartir inspiración con una comunidad de entusiastas de la moda.

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

#### 3. **Home/Feed**
- Dashboard principal con recomendaciones de outfits (Placeholder por el momento - En sprint 3 tendrá las funcionalidades completas)
- Feed de la comunidad para explorar estilos e inspiración
- Navegación a funcionalidades principales

#### 4. **Wardrobe (Guardarropa)**
- **Wardrobe Screen** - Visualización y gestión del guardarropa completo
- **Add Garment** - Agregar nuevas prendas con fotos e información
- **Garment Detail** - Vista detallada de cada prenda con edición
- **Filtros avanzados** - Por categoría, color, estilo, etiquetas y ocasiones
- **Recomendaciones IA** - Sugerencias inteligentes de outfits
- **Tags personalizados** - Sistema flexible de etiquetado

#### 5. **Community (Comunidad)**
- **Feed Screen** - Explorar publicaciones de la comunidad
- **Create Post** - Compartir outfits e inspiración
- **Comentarios e interacciones** - Comentar y dar "me gusta" a publicaciones
- **Descubrir estilos** - Encontrar nuevas tendencias e ideas

#### 6. **Profile (Perfil)**
- Gestión de perfil de usuario
- Configuración de preferencias de estilo
- Actualizar medidas y datos personales
- Cerrar sesión

## Navegación entre Flujos

### Desde Welcome
- **"Iniciar sesión"** → Pantalla de Signin
- **"Registrarse"** → Pantalla de Signup

### Desde Signin
- **"Crear cuenta"** → Reemplaza con Signup
- **Botón atrás** → Vuelve a Welcome
- **Login exitoso** → Navega a Home/Feed

### Desde Signup
- **"Iniciar sesión"** → Reemplaza con Signin
- **Botón atrás** → Vuelve a Welcome
- **Registro exitoso** → Navega a Onboarding

### Desde Onboarding
- **Completar proceso** → Navega a Home/Feed
- **Pasos**: Gender → Fill Profile → Measurements → Style → Additional Info

### Desde Home/Feed
- **Icono guardarropa** → Navega a Wardrobe
- **Icono perfil** → Navega a Profile
- **Crear publicación** → Navega a Create Post

### Desde Wardrobe
- **Agregar prenda** → Navega a Add Garment
- **Seleccionar prenda** → Navega a Garment Detail
- **Botón atrás** → Regresa a Home/Feed

### Desde Community
- **Crear publicación** → Navega a Create Post
- **Botón atrás** → Regresa a Home/Feed

### Rutas Principales
```dart
AppRoutes.welcome       // /welcome
AppRoutes.signin        // /signin
AppRoutes.signup        // /signup
AppRoutes.onboarding    // /onboarding (después de signup exitoso)
AppRoutes.home          // /home (feed principal)
AppRoutes.wardrobe      // /wardrobe
AppRoutes.addGarment    // /add-garment
AppRoutes.garmentDetail // /garment-detail/:id
AppRoutes.feed          // /feed
AppRoutes.createPost    // /create-post
AppRoutes.profile       // /profile
```

## Estructura del Código

```text
lib/
├── main.dart
└── features/
    ├── auth/                   # Flujo de autenticación
    │   ├── data/              # Repositorios e implementaciones
    │   ├── domain/            # Casos de uso y entidades
    │   │   └── usescases/     # Login, Logout, Register
    │   └── ui/
    │       ├── screens/       # Signin, Signup
    │       ├── widgets/       # AuthAppBar
    │       └── bloc/          # SigninBloc, SignupBloc
    │
    ├── onboarding/            # Flujo de configuración inicial
    │   ├── data/              # Modelos y repositorios
    │   ├── domain/            # Entidades y casos de uso
    │   │   └── usecases/      # CompleteOnboarding, GetAvailableColors, GetAvailableStyles
    │   └── ui/
    │       ├── screens/       # Onboarding screen
    │       ├── widgets/       # Pasos del onboarding
    │       └── bloc/          # OnboardingBloc
    │
    ├── wardrobe/              # Gestión de guardarropa
    │   ├── data/              # Repositorios e implementaciones
    │   │   └── source/        # StorageDataSource, WardrobeDataSource
    │   ├── domain/            # Modelos y casos de uso
    │   │   ├── model/         # Category, ColorOption, StyleOption, Tag, OccasionOption
    │   │   ├── repository/    # WardrobeRepository
    │   │   └── usecases/      # AddGarment, GetGarments, UpdateGarment, etc.
    │   └── ui/
    │       ├── screens/       # WardrobeScreen, AddGarmentScreen, GarmentDetailScreen
    │       ├── widgets/       # GarmentGridTile, FilterSection, AIRecommendations, etc.
    │       └── bloc/          # WardrobeBloc
    │
    ├── community/             # Características sociales
    │   ├── data/              # Repositorios e implementaciones
    │   ├── domain/            # Modelos y casos de uso
    │   │   ├── model/         # Post, Comment
    │   │   ├── repository/    # CommunityRepository
    │   │   └── usecases/      # CreatePost, GetFeed
    │   └── ui/
    │       ├── screens/       # FeedScreen, CreatePostScreen
    │       └── bloc/          # CommunityBloc
    │
    └── profile/               # Gestión de perfil
        ├── data/              # Repositorios e implementaciones
        ├── domain/            # Casos de uso
        │   └── usecases/      # GetProfile, UpdateProfile, DeleteProfile, SignOut, WhoAmI
        └── ui/
            ├── screens/       # Profile screen
            └── bloc/          # ProfileBloc
