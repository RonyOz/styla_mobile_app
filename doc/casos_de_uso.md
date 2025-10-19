# Casos de Uso - Styla MVP

Este documento describe los casos de uso principales para el MVP de Styla, organizados por módulos funcionales y mapeables a casos de uso de Clean Architecture.

## Índice de Casos de Uso

### Autenticación y Onboarding

1. Registro de usuario ✓
2. Inicio de sesión ✓
3. Completar perfil de usuario ✓
4. Configurar preferencias de estilo ✓

### Gestión del Guardarropa - 1 FDS

5. Agregar prenda al guardarropa
6. Etiquetar prenda
7. Visualizar guardarropa
8. Filtrar prendas
9. Editar información de prenda
10. Eliminar prenda del guardarropa

### Comunidad y Social - 1 FDS

11. Crear post con outfit
12. Visualizar feed de comunidad
13. Dar like a post
14. Comentar post
15. Guardar outfit de inspiración
16. Visualizar perfil de otro usuario
17. Seguir/Dejar de seguir usuario
18. Ver outfits guardados como inspiración

### Recomendaciones con IA - 0.5 FDS

19. Obtener recomendación rápida de outfit
20. Generar recomendación personalizada con prompt
21. Solicitar recomendación por tags

### Planificación de Outfits - 1 FDS

22. Asignar outfit a día específico
23. Planificar outfits semanales
24. Agregar notas a outfit planificado
25. Visualizar calendario de outfits
26. Vestir outfit ahora

---

## Descripción Detallada de Casos de Uso

### Autenticación y Onboarding

#### 1. Registro de usuario

El usuario ingresa su correo electrónico y contraseña para crear una cuenta nueva en la aplicación. Este caso de uso valida que el correo no esté registrado previamente, verifica que la contraseña cumpla con los requisitos de seguridad y crea el registro en el sistema de autenticación. Como resultado, el usuario queda registrado en la base de datos y es redirigido al flujo de onboarding para completar su perfil y configurar sus preferencias iniciales.

#### 2. Inicio de sesión

El usuario ingresa sus credenciales (correo y contraseña) para acceder a la aplicación. El sistema valida las credenciales contra la base de datos de autenticación y, si son correctas, genera una sesión activa para el usuario. Como resultado, el usuario queda autenticado y es redirigido a la pantalla principal de la aplicación, donde puede acceder a todas las funcionalidades de su guardarropa y recomendaciones.

#### 3. Completar perfil de usuario

El usuario proporciona información personal básica como género, medidas corporales, y preferencias iniciales durante el proceso de onboarding. Este caso de uso almacena los datos del perfil del usuario en la base de datos para personalizar la experiencia. Como resultado, el sistema cuenta con la información necesaria para generar recomendaciones más precisas y adaptadas al estilo y características físicas del usuario.

#### 4. Configurar preferencias de estilo

El usuario selecciona sus estilos favoritos, colores preferidos, y ocasiones de uso más frecuentes durante el onboarding. Este caso de uso registra estas preferencias en el perfil del usuario para que el motor de IA pueda considerarlas al generar recomendaciones. Como resultado, el sistema personaliza las sugerencias de outfits según los gustos declarados del usuario, mejorando la relevancia de las recomendaciones desde el primer día.

### Gestión del Guardarropa

#### 5. Agregar prenda al guardarropa

El usuario captura o selecciona una foto de una prenda desde su galería y la clasifica en una categoría específica (camisa, pantalón, zapatos, accesorios). Este caso de uso procesa la imagen, la almacena en el sistema de archivos o storage cloud, y crea un registro de la prenda en la base de datos vinculada al usuario. Como resultado, la prenda queda disponible en el guardarropa digital del usuario para ser utilizada en las recomendaciones de outfits y visualizada en la galería personal.

#### 6. Etiquetar prenda

El usuario asigna etiquetas a una prenda existente en su guardarropa, especificando atributos como color, estilo (casual, formal, deportivo) y ocasión de uso (trabajo, fiesta, casual). Este caso de uso actualiza los metadatos de la prenda en la base de datos con las etiquetas seleccionadas. Como resultado, el sistema puede filtrar y recomendar la prenda de manera más precisa según el contexto solicitado por el usuario o las condiciones del día.

#### 7. Visualizar guardarropa

El usuario accede a la sección de guardarropa para ver todas sus prendas organizadas. Este caso de uso recupera las prendas del usuario desde la base de datos y las presenta en formato de cuadrícula o lista según la preferencia seleccionada. Como resultado, el usuario puede navegar fácilmente por su colección completa de ropa, visualizar las fotos de cada prenda y acceder rápidamente a los detalles o acciones disponibles.

#### 8. Filtrar prendas

El usuario aplica uno o varios filtros (categoría, color, estilo, ocasión) para reducir la cantidad de prendas mostradas en su guardarropa. Este caso de uso ejecuta una consulta filtrada en la base de datos según los criterios seleccionados y devuelve únicamente las prendas que coinciden. Como resultado, el usuario encuentra rápidamente prendas específicas sin necesidad de desplazarse por toda su colección, optimizando la experiencia de búsqueda.

#### 9. Editar información de prenda

El usuario selecciona una prenda de su guardarropa para modificar su categoría, etiquetas, o reemplazar la foto. Este caso de uso actualiza los datos de la prenda en la base de datos con la nueva información proporcionada. Como resultado, la prenda refleja los cambios realizados y el sistema ajusta las recomendaciones futuras según las nuevas características de la prenda.

#### 10. Eliminar prenda del guardarropa

El usuario decide remover una prenda de su guardarropa porque ya no la posee o no desea incluirla en las recomendaciones. Este caso de uso elimina el registro de la prenda de la base de datos y opcionalmente borra la imagen asociada del storage. Como resultado, la prenda desaparece del guardarropa del usuario y deja de ser considerada en las futuras recomendaciones de outfits.


### Comunidad y Social

#### 11. Crear post con outfit

El usuario selecciona un outfit de su guardarropa o crea uno nuevo y lo publica en el foro comunitario con una foto y opcionalmente una descripción o contexto. Este caso de uso crea un nuevo post público en la base de datos vinculado al usuario autor, almacena la imagen del outfit y lo hace visible en el feed de la comunidad. Como resultado, el post queda publicado y otros usuarios pueden verlo, darle like, comentar y guardarlo como inspiración, fomentando la interacción social y el intercambio de ideas de estilo.

#### 12. Visualizar feed de comunidad

El usuario accede a la sección de comunidad para explorar los outfits publicados por otros usuarios de la aplicación. Este caso de uso recupera los posts más recientes o relevantes desde la base de datos y los presenta en un feed scrollable con las fotos de los outfits y la información del autor. Como resultado, el usuario puede descubrir nuevas combinaciones, obtener inspiración de estilos diferentes y conocer tendencias dentro de la comunidad de Styla.

#### 13. Dar like a post

El usuario presiona el botón de like en un post del feed comunitario para expresar que le gusta el outfit publicado. Este caso de uso registra la interacción en la base de datos incrementando el contador de likes del post y vinculando al usuario con el post. Como resultado, el autor del post recibe feedback positivo, el contador de likes se actualiza visualmente, y el sistema puede utilizar esta información para rankear posts populares y generar recomendaciones basadas en las preferencias de la comunidad.

#### 14. Comentar post

El usuario escribe un comentario en un post de la comunidad para expresar su opinión, hacer preguntas o felicitar al autor. Este caso de uso crea un nuevo registro de comentario en la base de datos vinculado al post y al usuario autor del comentario. Como resultado, el comentario queda visible para todos los usuarios que vean el post, fomentando la conversación y el intercambio de ideas entre miembros de la comunidad.

#### 15. Guardar outfit de inspiración

El usuario encuentra un outfit publicado por otro usuario que le gusta y decide guardarlo en su colección personal de inspiración. Este caso de uso crea una referencia en la base de datos que vincula el post guardado con el usuario, similar a un sistema de bookmarks. Como resultado, el usuario puede acceder posteriormente a todos los outfits guardados en una sección dedicada para consultarlos cuando necesite ideas o inspiración para crear sus propias combinaciones.

#### 16. Visualizar perfil de otro usuario

El usuario navega al perfil público de otro miembro de la comunidad para ver sus posts publicados, su estilo y su actividad. Este caso de uso recupera la información pública del perfil del usuario seleccionado y sus posts desde la base de datos. Como resultado, el usuario puede conocer el estilo de otros usuarios, explorar su galería de outfits publicados y decidir si desea seguirlos para recibir sus actualizaciones en su feed personalizado.

#### 17. Seguir/Dejar de seguir usuario

El usuario decide seguir a otro miembro de la comunidad para recibir sus publicaciones en su feed personalizado, o deja de seguirlo si ya no desea ver su contenido. Este caso de uso crea o elimina una relación de seguimiento en la base de datos entre el usuario actual y el usuario objetivo. Como resultado, el feed del usuario se personaliza mostrando prioritariamente los posts de los usuarios que sigue, creando una experiencia más relevante y construyendo una red social dentro de la aplicación.

#### 18. Ver outfits guardados como inspiración

El usuario accede a su colección personal de outfits guardados para revisar las combinaciones que le gustaron de otros usuarios. Este caso de uso recupera todos los posts que el usuario ha guardado previamente desde la base de datos y los presenta en una galería organizada. Como resultado, el usuario tiene acceso rápido a su biblioteca de inspiración para consultarla cuando necesite ideas para crear nuevas combinaciones o planificar su vestimenta.

### Recomendaciones con IA

#### 19. Obtener recomendación rápida de outfit

El usuario presiona el botón de "Recomendar outfit" para recibir una sugerencia inmediata sin especificar parámetros adicionales. Este caso de uso consulta el guardarropa del usuario, sus preferencias de estilo, y opcionalmente el clima actual para generar una combinación de prendas mediante el motor de IA. Como resultado, el usuario visualiza un outfit completo sugerido con las fotos de las prendas seleccionadas, que puede aceptar, modificar o solicitar otra recomendación.

#### 20. Generar recomendación personalizada con prompt

El usuario escribe un texto libre describiendo el tipo de outfit que desea (por ejemplo, "outfit elegante para cena de negocios" o "look casual para el fin de semana"). Este caso de uso procesa el prompt mediante el motor de IA para interpretar la intención y genera una recomendación de outfit que cumple con los criterios especificados, utilizando las prendas disponibles en el guardarropa. Como resultado, el usuario obtiene una combinación personalizada que responde exactamente a su necesidad o contexto específico.

#### 21. Solicitar recomendación por tags

El usuario selecciona uno o varios tags específicos (por ejemplo, "elegante", "negro", "blanco") para filtrar el tipo de recomendación que desea recibir. Este caso de uso utiliza estos tags como criterios de búsqueda y restricciones para que el motor de IA genere un outfit que incluya solo prendas con las características solicitadas. Como resultado, el usuario recibe una recomendación que cumple con las restricciones de color, estilo u ocasión especificadas mediante los tags.

### Planificación de Outfits

#### 22. Asignar outfit a día específico

El usuario selecciona un outfit recomendado o creado manualmente y lo asigna a una fecha específica en su calendario semanal o mensual. Este caso de uso crea un registro en la base de datos que vincula el outfit con la fecha seleccionada. Como resultado, el usuario tiene planificado qué vestir en ese día particular y puede visualizarlo posteriormente en su calendario de outfits.

#### 23. Planificar outfits semanales

El usuario accede al planificador semanal para visualizar u organizar los outfits de toda la semana de manera conjunta. Este caso de uso recupera los outfits ya asignados a cada día de la semana actual y permite al usuario agregar, modificar o eliminar asignaciones. Como resultado, el usuario tiene una visión completa de su semana en términos de vestimenta, lo que facilita la organización y evita repeticiones no deseadas.

#### 24. Agregar notas a outfit planificado

El usuario escribe una nota o comentario asociado a un outfit ya planificado para recordar el contexto de uso (por ejemplo, "cena con amigos" o "reunión importante"). Este caso de uso actualiza el registro del outfit planificado en la base de datos agregando el texto de la nota. Como resultado, el usuario puede consultar posteriormente por qué eligió ese outfit específico y tener contexto adicional al revisar su calendario.

#### 25. Visualizar calendario de outfits

El usuario accede a una vista de calendario que muestra todos los outfits planificados para cada día del mes o semana actual. Este caso de uso recupera los outfits asignados desde la base de datos y los presenta en un formato de calendario visual. Como resultado, el usuario puede tener una visión panorámica de su planificación de vestimenta, identificar días sin outfit asignado y navegar fácilmente entre fechas para gestionar su planificación.

#### 26. Vestir outfit ahora

El usuario selecciona un outfit recomendado o planificado y lo marca como "vestir ahora" para indicar que lo usará inmediatamente. Este caso de uso registra el outfit como usado en el historial del usuario con la fecha y hora actual. Como resultado, el sistema actualiza las estadísticas de uso de cada prenda del outfit, genera datos para el seguimiento de evolución personal, y el usuario puede llevar un registro de qué outfits ha utilizado a lo largo del tiempo.

---

## Mapeo a Clean Architecture

Cada caso de uso descrito en este documento puede implementarse como un caso de uso (Use Case) en la capa de dominio de Clean Architecture:

- **Capa de Dominio (domain/)**: Cada caso de uso se implementa como una clase independiente que contiene la lógica de negocio pura.
- **Capa de Datos (data/)**: Los repositorios proveen las interfaces para acceder a fuentes de datos (Supabase, APIs, storage).
- **Capa de Presentación (ui/)**: Los BLoCs orquestan la ejecución de los casos de uso y gestionan el estado de la interfaz.

Esta separación permite testear cada caso de uso de forma aislada, mantener el código desacoplado y facilitar futuras extensiones del MVP.
