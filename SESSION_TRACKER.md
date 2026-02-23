# SESSION TRACKER

## Rol operativo permanente (MeteoKite Master Prompt v2)

Referencia: `/home/clw/Documentos/Proyectos/Flutter/MeteoKite/meteokite/docs/MeteoKite_Master_Prompt_v2.md`

Actuo como cofundador tecnico y estrategico con estos roles activos:

- Arquitectura: Senior Flutter Architect, Principal Software Engineer, Systems Architect, Performance Engineer
- Dominio: Meteorological Data Specialist, Geospatial Engineer, Sensor and Motion Data Engineer
- Producto: Product Manager, UX Researcher
- Diseno: UX/UI Lead outdoor sports, Design Systems Architect, UI Systems Engineer, Accessibility Specialist
- Competicion: Game Systems Designer
- Kitesurf Performance & Competition Expert: Rider con +30 años de experiencia real en Freeride, Freestyle y Big Air, compitiendo a nivel internacional y navegando en spots de referencia mundial (condiciones onshore, side-on, offshore, térmicos, frentes, viento racheado, mar de fondo y choppy extremo). Experto en lectura avanzada de viento, análisis de ráfagas, gradientes térmicos, interacción viento-ola-corriente, selección óptima de material (kite, líneas, tabla, trims), gestión de riesgo, toma de decisiones bajo presión y optimización del rendimiento según nivel del rider. Capaz de traducir datos meteorológicos crudos en decisiones tácticas reales de navegación y competición.
- Open source: Open Source Governance Advisor, Community Lead
- Seguridad y escalabilidad: Security Engineer, Cloud and Backend Strategist

## Registro de sesiones

### 2026-02-21 - Bootstrap de contexto y preparacion

- Leido y adoptado el master prompt del proyecto para guiar decisiones.
- Instalada skill externa `ui-ux-pro-max` en `/home/clw/.agents/skills/ui-ux-pro-max`.
- Configurado MCP de Google Stitch en `/.opencode/opencode.json` del proyecto v2.0.
- Validado binario MCP con `npx -y @_davideast/stitch-mcp --help`.
- Revisada pantalla login de MeteoKite 1.0 en `lib/features/auth/presentation/pages/login_page.dart`.
- Diseñado enfoque de replica de login para v2.0.
- Creado diseno: `docs/plans/2026-02-21-login-screen-replica-design.md`.
- Creado plan de implementacion: `docs/plans/2026-02-21-login-screen-replica-implementation.md`.

### 2026-02-21 - Implementacion inicial de login (replica v1.0)

- Migrado bootstrap de app a `ProviderScope` + `GoRouter` en `lib/main.dart`.
- Anadidas rutas base en `lib/app/router/app_routes.dart` y `lib/app/router/app_router.dart`.
- Anadido dashboard placeholder en `lib/features/dashboard/presentation/pages/dashboard_page.dart`.
- Anadidos providers de auth:
  - `lib/features/auth/presentation/providers/auth_session_provider.dart`
  - `lib/features/auth/presentation/providers/recent_auth_accounts_provider.dart`
- Anadidos soporte minimo de config/tema:
  - `lib/core/config/env/env_config.dart`
  - `lib/core/theme/app_spacing.dart`
- Replicada UI/flujo de login v1.0 en `lib/features/auth/presentation/pages/login_page.dart`.
- Reemplazado test plantilla por test de arranque real en `test/widget_test.dart`.
- Tests creados y en verde:
  - `test/app/app_bootstrap_test.dart`
  - `test/features/auth/presentation/providers/auth_session_provider_test.dart`
  - `test/features/auth/presentation/providers/recent_auth_accounts_provider_test.dart`
  - `test/features/auth/presentation/pages/login_page_test.dart`
  - `test/widget_test.dart`
- Verificacion ejecutada: `flutter test -r expanded && flutter analyze` (ok).

## Proximo paso acordado

- Integrar capa `domain/data` de auth para alinear el feature con Clean Architecture feature-first.

### 2026-02-21 - Puente temporal de login en desarrollo

- Activado arranque directo a dashboard cuando `EnvConfig.devBypassEnabled` esta en `true`.
- Cambio aplicado en router: `lib/app/router/app_router.dart` (initialLocation condicional).
- Manteniendo ruta `/login` disponible para pruebas manuales de la pantalla sin tocar su implementacion.
- Tests actualizados para reflejar el nuevo arranque en desarrollo:
  - `test/app/app_bootstrap_test.dart`
  - `test/widget_test.dart`
- Verificacion ejecutada: `flutter test -r expanded` (ok).

### 2026-02-21 - Dashboard con pestañas principales

- Reemplazada vista unica de dashboard por navegacion principal con 4 pestañas en `lib/features/dashboard/presentation/pages/dashboard_page.dart`.
- Pestañas implementadas manteniendo estilo Material de la app (AppBar + `NavigationBar` + contenido en `Card`):
  - `Spots`
  - `Session`
  - `Community`
  - `Perfil`
- Añadido cambio de contenido por pestaña con `AnimatedSwitcher` para transicion suave.
- Tests de arranque actualizados para reflejar la nueva navegacion:
  - `test/app/app_bootstrap_test.dart`
  - `test/widget_test.dart`
- Verificacion ejecutada: `flutter test -r expanded && flutter analyze` (ok).

### 2026-02-21 - Conexion de tabs a features base

- Conectadas las 4 pestañas del dashboard a pantallas de feature reales con `IndexedStack` en `lib/features/dashboard/presentation/pages/dashboard_page.dart`:
  - `SpotsPage`
  - `SessionsPage`
  - `CommunityPage`
  - `ProfilePage`
- Creadas pantallas base manteniendo estilo actual (padding + `Card` + tipografia del tema):
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/community/presentation/pages/community_page.dart`
  - `lib/features/profile/presentation/pages/profile_page.dart`
- Ajustada compatibilidad Riverpod 3 en recientes de auth (reemplazo de `StateProvider` por `NotifierProvider`) en `lib/features/auth/presentation/providers/recent_auth_accounts_provider.dart`.
- Verificacion ejecutada: `flutter analyze && flutter test -r expanded` (ok).

### 2026-02-21 - Spots: flujo inicial de alta desde FAB

- Evolucionada `SpotsPage` a estado local para soportar alta de spots en UI.
- FAB de `Spots` ahora abre un modal (`showModalBottomSheet`) para anadir spot manualmente.
- Formulario inicial en modal:
  - `Nombre del spot` (obligatorio)
  - `Zona / provincia` (opcional)
- Al guardar, el spot aparece en lista de cards dentro de la pestaña `Spots`.
- Estado vacio incluido cuando no hay spots agregados.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test -r expanded` (ok).

### 2026-02-21 - Spots: sugerencias en alta por nombre

- El modal de `Agregar spot` ahora sugiere spots disponibles mientras el usuario escribe el nombre.
- Implementado filtrado incremental (hasta 5 coincidencias) sobre lista base de spots iniciales de Espana.
- Al tocar una sugerencia, se autocompletan `Nombre del spot` y `Zona / provincia`.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: modo personalizado con punto en mapa

- Anadido boton `Personalizado` en el modal de alta de spot.
- El flujo `Personalizado` abre dialogo de mapa (modo desarrollo) para marcar un punto tocando el area.
- Al confirmar `Usar punto`:
  - se guarda la seleccion visual,
  - se autocompleta zona con coordenada aproximada,
  - se mantiene compatible con guardado del spot.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: mapa real open source en modo personalizado

- Reemplazado el selector visual simulado por mapa real en el dialogo de `Personalizado` usando stack 100% open source:
  - `flutter_map` (licencia BSD/MIT-compatible, open source)
  - `latlong2` (open source)
  - tiles de OpenStreetMap para desarrollo
- El usuario ahora marca el punto sobre mapa real y se conserva el flujo de autocompletado de coordenadas aproximadas en la zona.
- Dependencias actualizadas en `pubspec.yaml`:
  - `flutter_map`
  - `latlong2`
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
  - `pubspec.yaml`
- Verificacion ejecutada: `flutter pub get && flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: estado activo, duplicados y borrado

- Mejorado flujo de gestion de `Mis spots` en la UI:
  - el primer spot agregado pasa a estado activo automaticamente,
  - se puede cambiar el spot activo tocando una tarjeta,
  - se muestra chip `Activo` en el spot seleccionado,
  - se puede eliminar spot desde accion de papelera.
- Mejorado modal de alta para evitar duplicados:
  - las sugerencias excluyen spots ya agregados,
  - se bloquea el guardado si el nombre ya existe (`Ese spot ya esta agregado`).
- Mantenido enfoque gratuito/open source (sin servicios propietarios).
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: edicion restringida a spots personalizados

- Implementada edicion de spots con regla de negocio solicitada:
  - solo se puede editar un spot si es `personalizado`,
  - los spots de lista predefinida no abren flujo de edicion.
- Flujo de edicion:
  - se abre modal en modo `Editar spot`,
  - permite guardar cambios de nombre/zona,
  - mantiene validacion de duplicados.
- Ajustes de estado:
  - si el spot activo se renombra, el estado activo se actualiza al nuevo nombre.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: chips visuales Oficial/Custom

- Mejorada la claridad visual en la lista de spots anadidos:
  - spots de lista predefinida muestran chip `Oficial`,
  - spots personalizados muestran chip `Custom`,
  - se mantiene chip `Activo` para el spot seleccionado.
- Esto refuerza la regla de negocio: solo `Custom` se puede editar.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: filtros por tipo (Todos/Oficiales/Custom)

- Anadido filtro visual en la pestaña `Spots` para manejar mejor listas crecientes:
  - `Todos`
  - `Oficiales`
  - `Custom`
- El listado ahora se renderiza en base al filtro seleccionado.
- Si un filtro no tiene resultados, se muestra estado vacio contextual (`No hay spots para este filtro`).
- Se mantienen reglas previas:
  - edicion solo para spots `Custom`,
  - spots oficiales no editables,
  - stack gratuito/open source sin servicios propietarios.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: buscador combinado con filtros

- Anadido buscador en la cabecera de lista de spots (`Buscar spots`).
- El filtrado ahora combina:
  - tipo (`Todos` / `Oficiales` / `Custom`),
  - texto (coincidencia por nombre o zona).
- Incluye accion para limpiar busqueda (`Limpiar busqueda`).
- Se mantiene estado vacio contextual cuando no hay coincidencias.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: ordenacion de lista

- Anadidos controles de ordenacion para `Mis spots`:
  - `Recientes`
  - `A-Z`
  - `Z-A`
- La ordenacion se aplica sobre el resultado final de filtros + buscador.
- Se agrega sello temporal (`createdAt`) al modelo UI de spot para soportar orden por recientes de forma estable.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: selector de mapa mas grande y puntero visible

- Mejorado el flujo `Personalizado` al seleccionar punto en mapa:
  - el dialogo del mapa ahora es mas grande y usable en movil,
  - se renderiza un puntero rojo claramente visible justo donde se toca el mapa,
  - se mantiene confirmacion `Usar punto` y estado `Punto listo para usar`.
- Ajuste tecnico: el punto personalizado ahora conserva fracciones de posicion (`xFraction`, `yFraction`) para dibujar el puntero de forma precisa en el canvas del mapa.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: correccion de estirado horizontal en overscroll

- Corregido el efecto visual en `Spots` cuando se hace overscroll vertical (arriba/abajo):
  - se mantiene sensacion tipo muelle vertical,
  - se elimina la deformacion horizontal de pantalla.
- Implementado con `ScrollConfiguration` local sin indicador stretch y `BouncingScrollPhysics` en la lista principal.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spots_page.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: ocultar icono editar en oficiales

- Ajuste UX solicitado en lista de spots:
  - en spots `Oficial` ya no se muestra icono de editar desactivado,
  - el icono de editar solo aparece en spots `Custom`.
- Se mantiene la regla funcional previa (solo custom editable).
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: acciones mover a AppBar

- Refactor UX solicitado en `Spots`:
  - se eliminan iconos de `editar/eliminar` en cada tarjeta,
  - las acciones se gestionan desde un menu en la `AppBar` de dashboard (solo visible en tab Spots).
- Menu AppBar en `Spots` incluye:
  - `Editar spot activo`
  - `Eliminar spot activo`
- Comportamiento:
  - opera siempre sobre el spot marcado como `Activo`,
  - mantiene la regla de negocio: solo custom editable (en oficiales se muestra feedback por snackbar).
- Archivos actualizados:
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: eliminado concepto de "spot activo"

- Se retira completamente el concepto de `spot activo` por feedback de UX.
- Cambios aplicados:
  - eliminado chip `Activo` en tarjetas,
  - eliminada seleccion por tap para marcar activo,
  - menu AppBar deja de operar sobre "activo" y pasa a operar por seleccion explicita.
- Nuevos flujos desde AppBar:
  - `Editar spot`: abre selector de spots custom (si hay mas de uno) y luego editor,
  - `Eliminar spot`: abre selector de spots y elimina el seleccionado.
- Ajustes en dashboard:
  - textos de menu simplificados (`Editar spot`, `Eliminar spot`).
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: editar/eliminar desde tarjetas tras activar modo en AppBar

- Ajuste UX solicitado: al pulsar `Editar spot` o `Eliminar spot` en AppBar ya no aparece selector modal de spots.
- Nuevo comportamiento:
  - AppBar activa un modo temporal (`editar` o `eliminar`),
  - el usuario ejecuta la accion tocando directamente una tarjeta en la pantalla de spots,
  - tras aplicar la accion, el modo se desactiva automaticamente.
- Se muestra aviso contextual mientras el modo esta activo:
  - `Modo editar: toca una tarjeta para editarla`
  - `Modo eliminar: toca una tarjeta para borrarla`
- Reglas conservadas:
  - editar solo para `Custom`,
  - en spot `Oficial` se informa por snackbar.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: soporte de acciones multiples (editar/eliminar varios)

- Anadida opcion de acciones multiples en menu de AppBar para Spots:
  - `Editar varios`
  - `Eliminar varios`
- Flujo UX:
  - al activar modo multiple, se seleccionan tarjetas directamente en pantalla,
  - se muestra contador de seleccionados y acciones `Cancelar` / `Aplicar`.
- `Editar varios` (solo custom):
  - permite seleccionar varios spots custom,
  - aplica cambio masivo de `Zona / provincia` via modal.
- `Eliminar varios`:
  - permite seleccionar varios spots y borrarlos en una sola accion.
- Se mantiene tambien modo simple por tarjetas para `Editar spot` y `Eliminar spot`.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: acciones solo en modo multiple

- Ajuste de producto por feedback:
  - se elimina el flujo de editar/eliminar de uno en uno,
  - se mantiene exclusivamente operativa la gestion por lotes (`Editar varios`, `Eliminar varios`).
- UX final:
  - activas modo desde AppBar,
  - seleccionas tarjetas,
  - confirmas con `Aplicar`.
- Limpieza tecnica asociada:
  - eliminadas rutas y estado de accion simple,
  - simplificado formulario de alta para uso exclusivo de creacion (sin modo editar).
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: menu simplificado (Editar uno, Eliminar en lote)

- Ajuste UX solicitado:
  - `Editar` pasa a flujo de un solo spot (seleccionando tarjeta en modo editar).
  - `Eliminar` mantiene comportamiento en lote, pero sin texto "varios" en el menu.
- Se conserva opcion explicita `Editar varios` para cambios masivos de zona en custom.
- Menu final en AppBar de Spots:
  - `Editar`
  - `Editar varios`
  - `Eliminar`
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: ajuste final acciones (Editar 1, Eliminar lote)

- Ajuste final por feedback:
  - `Editar varios` eliminado,
  - `Editar` queda solo para 1 spot cada vez,
  - `Eliminar` mantiene seleccion multiple por tarjetas.
- Menu final en AppBar de Spots:
  - `Editar`
  - `Eliminar`
- Comportamiento:
  - `Editar`: activa modo editar simple y abre formulario al tocar un spot custom,
  - `Eliminar`: activa modo seleccion multiple y elimina seleccionados al pulsar `Aplicar`.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spots: navegacion a detalle de spot y volver atras

- Al pulsar una tarjeta de spot en modo normal (sin accion pendiente), ahora navega a pantalla de detalle del spot.
- Nueva pantalla de detalle con AppBar propia y vuelta atras desde el boton del AppBar.
- Se conserva comportamiento existente en modos de accion:
  - `Editar` (1 a 1) y `Eliminar` (lote) siguen operando sobre tarjetas.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
  - `lib/features/spots/presentation/pages/spots_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spot detalle: AppBar simplificado y toggle de secciones

- Ajuste solicitado en pantalla de spot seleccionado:
  - titulo de AppBar cambiado de nombre del spot a `Spot seleccionado`,
  - se mantiene boton de volver atras en AppBar.
- Debajo de la tarjeta principal se anade selector tipo toggle con 4 vistas:
  - `Prevision`
  - `Live`
  - `Webcam`
  - `Social`
- Cada vista muestra bloque placeholder inicial para evolucionar contenido funcional por seccion.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r expanded` (ok).

### 2026-02-21 - Spot detalle: etiqueta Prevision -> Forecast

- Cambio de copy en toggle de secciones de spot seleccionado:
  - `Prevision` pasa a `Forecast`.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`

### 2026-02-21 - Spot detalle: toggle compact para labels en una linea

- Ajustado el toggle de secciones en detalle de spot para que ocupe menos ancho visual y no rompa texto en varias lineas.
- Cambios aplicados:
  - estilo compact (`VisualDensity.compact`),
  - menor padding horizontal,
  - labels con `softWrap: false`,
  - scroll horizontal suave del conjunto para mantener legibilidad en pantallas pequenas.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Reversion toggle compact en detalle de spot

- Revertidos los cambios de compactacion del toggle en detalle de spot por decision de UX.
- Se restaura comportamiento/estilo anterior del `SegmentedButton`.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`

### 2026-02-21 - Spot detalle: quitar efecto muelle horizontal

- Ajustada la pantalla `Spot seleccionado` para eliminar el efecto de arrastre tipo muelle al deslizar lateralmente (izquierda/derecha).
- Implementacion:
  - `ScrollConfiguration` local sin overscroll stretch,
  - `ClampingScrollPhysics` en la lista de detalle.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: Forecast con selector de proveedor meteo

- En seccion `Forecast` se elimina la tarjeta de texto de prevision placeholder.
- En su lugar se anade una caja/select para elegir proveedor meteorologico disponible.
- Proveedores iniciales cargados en UI:
  - `Open-Meteo`
  - `AEMET`
  - `Windguru`
- Para `Live`, `Webcam` y `Social` se mantiene tarjeta placeholder de contenido.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: tabla Forecast con oleaje/lluvia activables

- En `Forecast`, tras seleccionar proveedor meteo, se anade una tabla horaria estilo app de viento con columnas base:
  - `Hora`
  - `Viento (kt)`
  - `Racha (kt)`
- Se agregan parametros extra activables/desactivables con chips:
  - `Oleaje` (m)
  - `Lluvia` (si/no + mm)
- Los datos mostrados cambian por proveedor seleccionado (`Open-Meteo`, `AEMET`, `Windguru`) con dataset UI inicial.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: formato tipo Windguru + selector de modelo

- Refinado bloque `Forecast` hacia estilo visual tipo Windguru:
  - tabla compacta por filas metricas y columnas horarias,
  - celdas de viento/racha con codificacion de color,
  - lluvia con intensidad visual por color.
- Anadido selector de modelo de prevision:
  - `GFS`, `AROME`, `ICON`, `ECMWF`.
- Se mantiene selector de proveedor meteo y toggles activables:
  - `Oleaje`
  - `Lluvia`
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r compact` (ok).

### 2026-02-21 - Spot detalle: tabla Forecast mas grande

- Ajuste visual de la tabla en `Forecast` para mejorar legibilidad:
  - celdas mas grandes (padding aumentado),
  - tipografia subida a `bodyMedium`,
  - ancho de columna aumentado (de 82 a 98).
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: direccion viento + temperatura + presion

- Extendida la tabla `Forecast` para incluir parametros extra solicitados:
  - `Direccion` del viento con flecha orientada por grados,
  - `Temp (C)`,
  - `Presion (hPa)`.
- Se mantienen toggles para `Oleaje` y `Lluvia`.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: unidad direccion simplificada

- Ajustado formato de direccion del viento en tabla Forecast:
  - de `deg` a simbolo `º`.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`

### 2026-02-21 - Spot detalle: direccion solo con flecha grande

- Ajuste visual en columna de direccion del viento:
  - se elimina el texto de grados,
  - se usa solo flecha rotada por direccion,
  - flecha mas grande y definida (`arrow_upward_rounded`, size 22).
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: flecha direccion mas gruesa

- Ajuste visual adicional solicitado para la flecha de direccion del viento:
  - mismo icono/forma,
  - trazo mas grueso usando ejes de Material Symbols (`fill`, `weight`, `grade`) y tamano 24.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: nuevo icono direccion tipo puntero

- Cambiado el icono de direccion del viento por un modelo mas tipo puntero de raton (`near_me_rounded`) manteniendo la rotacion por grados.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: puntero con rabito en direccion

- Ajustado icono de direccion del viento a variante con rabito (`assistant_navigation`) manteniendo la rotacion por grados.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: revert icono direccion a near_me_rounded

- Revertido icono de direccion del viento al modelo anterior preferido (`near_me_rounded`).
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`

### 2026-02-21 - Spot detalle: cloud cover en tabla Forecast

- Anadido parametro `Cloud cover (%)` en la tabla Forecast.
- Se integra como nueva fila en el formato tipo Windguru junto al resto de variables meteo.
- Actualizado dataset UI mock de proveedores para incluir cobertura nubosa por hora.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: pantalla dedicada de mapa de viento

- El boton `Mapa de viento` ahora navega a pantalla dedicada en lugar de snackbar.
- Nueva pantalla `Mapa de viento` con:
  - base de mapa open source (OpenStreetMap via `flutter_map`),
  - capa visual de flechas/kt superpuesta estilo mapa de viento,
  - card inferior informativa del spot.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/wind_map_page.dart`
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
  - `test/features/spots/presentation/pages/spots_page_test.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/spots/presentation/pages/spots_page_test.dart -r compact` (ok).

### 2026-02-21 - Spot detalle: Live con lista de estaciones cercanas

- Reemplazado placeholder de `Live` por lista de estaciones meteorologicas cercanas al spot.
- Cada item muestra:
  - nombre de estacion,
  - proveedor,
  - distancia en km.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: Live con caja seleccionable de estacion

- Ajustado bloque `Live` para mostrar una caja seleccionable (dropdown) en lugar de listar todas las estaciones a la vez.
- La caja muestra nombre + distancia, y debajo se visualiza el proveedor de la estacion seleccionada.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: Live con rosa de vientos y unidad configurable

- Al seleccionar estacion en `Live`, ahora se muestra:
  - rosa de vientos con lectura real (direccion + velocidad),
  - selector de unidad de viento (`kt`, `km/h`, `mph`, `Bft`),
  - bloque de lecturas en tiempo real (viento, racha, temperatura, presion, humedad, lluvia).
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: chip semaforo de navegabilidad

- En tarjeta de rosa de los vientos se reemplaza el titulo por chip semaforo de navegabilidad.
- Estados implementados por rango de viento actual:
  - `Navegable` (verde)
  - `Condicional` (amarillo)
  - `No navegable` (rojo)
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: grafica historica en Live

- Anadida grafica de historico de lecturas reales debajo de las tarjetas de metricas en seccion `Live`.
- Implementada como linea + area en `CustomPainter` con serie de 12 puntos por estacion seleccionada.
- Mantiene coherencia con selector de estacion y unidad de viento.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: quitar toggles de lluvia/oleaje y anadir boton mapa

- Eliminados toggles de `Lluvia` y `Oleaje` en Forecast.
- Anadido boton `Mapa de viento` en su lugar.
- La tabla Forecast mantiene visibles las filas de oleaje y lluvia de forma fija.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: ajuste tipografia toggle (-1)

- Reducido 1 punto el tamano de letra del `SegmentedButton` en pantalla de spot seleccionado para mejorar encaje horizontal de labels.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-21 - Spot detalle: tipografia toggle a 11

- Ajuste adicional solicitado: labels del toggle de secciones en detalle de spot pasan a `fontSize: 11`.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`

### 2026-02-21 - Reversion tipografia toggle en spot detalle

- Revertidos los cambios de tamano de fuente del toggle de secciones.
- Se restaura la tipografia por defecto del `SegmentedButton` (estado inicial).
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`

### 2026-02-21 - Patron UI reutilizable para gestion de listas

- Queda registrado como patron para reutilizar en otras tabs/paginas:
  - accion simple desde AppBar (`Editar`) + accion en lote desde AppBar (`Eliminar`),
  - ejecucion directa sobre tarjetas (sin selector modal extra),
  - modo contextual visible con `Cancelar` / `Aplicar` cuando hay seleccion multiple.
- Objetivo: mantener consistencia UX en futuras implementaciones (Sessions, Community, Perfil, etc.).

### 2026-02-21 - IDE debug simplificado para recuperar Hot Reload

- Simplificada configuracion de `Run and Debug` para evitar lanzar por error modos sin Hot Reload.
- `launch.json` queda con una unica configuracion:
  - `Flutter Android Debug (Hot Reload)`
- Anadido `extensions.json` con recomendaciones de extensiones oficiales:
  - `dart-code.dart-code`
  - `dart-code.flutter`
- Archivos actualizados:
  - `.vscode/launch.json`
  - `.vscode/extensions.json`

### 2026-02-21 - Debug UX IDE: aclaracion de perfiles

- Ajustado `launch.json` para evitar confusion con Hot Reload en el IDE:
  - `Flutter Android (Profile - sin Hot Reload)`
  - `Flutter Attach (Android - requiere app ya iniciada)`
- Objetivo: dejar claro que Hot Reload solo aparece en sesion `Debug`.
- Archivo actualizado:
  - `.vscode/launch.json`

### 2026-02-22 - Spot detalle Social: mini red social por spot

- Sustituido el placeholder de `Social` por una version simple y util, sin apps externas.
- Flujo implementado en el propio spot:
  - publicacion de texto por usuario,
  - seleccion de tipo de media asociado al post (`Solo texto`, `Foto`, `Video corto`),
  - feed aislado por spot seleccionado (cada spot tiene su propio hilo),
  - respuestas en hilo por post (mini foro dentro del feed del spot).
- Incluye estado vacio cuando no hay publicaciones y seed inicial para spots no custom.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Spot detalle Social: simplificacion de adjuntos en composer

- Eliminados los chips de seleccion (`Solo texto`, `Foto`, `Video corto`) del formulario social.
- Sustituidos por un unico boton `Adjuntar foto/video`, con selector modal para:
  - adjuntar foto,
  - adjuntar video corto,
  - quitar adjunto.
- Se muestra estado compacto del adjunto activo junto al boton.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Spot detalle Social: publicaciones sin chips y gestion de post propio

- Ajustada la UX del feed social para parecerse a una red social clasica:
  - eliminados chips de tipo (`solo texto`, `foto`, `video`) en los posts publicados,
  - cuando hay adjunto se muestra bloque de media y el texto del post debajo.
- Anadido control sobre publicaciones propias (`Tu perfil`):
  - editar post,
  - eliminar post.
- El composer ahora soporta modo edicion con `Guardar cambios` y `Cancelar edicion`.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Spot detalle Social: endurecimiento ante errores de indices

- Anadidas validaciones defensivas en acciones de social para evitar `RangeError` por indices fuera de rango al editar, eliminar o responder.
- Se limpian estados de edicion/respuesta cuando el indice ya no es valido.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Spot detalle Social: respuestas en cascada tipo red social

- Extendida la logica de respuestas para permitir hilos en cascada (reply sobre reply), no solo respuesta al post raiz.
- Cada mensaje/respuesta puede recibir respuestas de otros usuarios y se renderiza como arbol de conversacion.
- Composer de respuesta unificado para post raiz o reply objetivo, con cancelacion y envio en contexto.
- Se mantiene feed por spot y acciones de edicion/eliminacion del post propio.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Hotfix Social: excepcion en replies (linea 1452)

- Corregida inicializacion de listas de respuestas para evitar estados no mutables/incompatibles en tiempo de ejecucion.
- En `_SpotSocialPost` y `_SpotSocialReply` ahora se clona siempre la lista de replies con `List.from(...)`.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Recuperacion parcial tras rollback accidental en Spot Detail

- Restaurada la seccion `Webcam` dentro de `SpotDetailPage`:
  - lista de webcams por spot,
  - estado vacio para spots sin camaras,
  - boton `Abrir` con navegacion a `WebcamPlayerPage`.
- Ajustes de social mantenidos compatibles tras la recuperacion.
- Archivo actualizado:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Restauracion de Live completo tras rollback

- Repuesto el bloque avanzado de `Live` en `SpotDetailPage`:
  - historico grande con zoom/pan,
  - comparativa con forecast (fuente + modelo),
  - refresco manual y fullscreen,
  - rango temporal `1h/3h/6h/12h`,
  - marcadores de direccion con semaforo en el chart.
- Restaurado tambien el bloque de `Alarmas personalizadas` como tarjeta separada bajo el historico.
- Archivos actualizados:
  - `lib/features/spots/presentation/pages/spot_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: vinculacion de dispositivo e importacion

- Implementado el placeholder avanzado de `Session` inspirado en flujo de captura con dispositivo externo:
  - boton superior derecho `Añadir dispositivo` con selector de tipo (Woo Sports, Apple Watch, Android, SurfR),
  - lista de dispositivos vinculados con seleccion del dispositivo activo para grabar,
  - bloque alternativo para `Importar sesion` desde archivo cuando no se usa dispositivo en agua.
- Se muestra estado de seleccion y mensaje de importacion en modo mock.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: lista de dispositivos modificable

- Extendida la lista de dispositivos vinculados para que sea editable:
  - editar nombre/estado del dispositivo,
  - eliminar dispositivo vinculado con confirmacion.
- Si se elimina el dispositivo seleccionado, la seleccion activa pasa al primero disponible (o null si no quedan).
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: control de sesion con estados (mock fase 1)

- Anadido bloque `Control de sesion` en la pantalla `Session` con flujo mock de captura:
  - `Iniciar sesion` -> `Detener sesion` -> `Sincronizar` -> `Nueva sesion`.
- Incluye estado contextual visible, timer de sesion activa y estado de sensores (GPS/Sensores OK) para simular comportamiento de wearable.
- El boton principal se adapta dinamicamente segun estado y dispositivo seleccionado.
- Si no hay dispositivo seleccionado, se bloquea el inicio con feedback.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: eliminado efecto muelle en pantalla

- Eliminado overscroll/efecto muelle al inicio y final de la pantalla `Session`.
- Aplicado `ScrollConfiguration` sin indicador de overscroll y `ClampingScrollPhysics` en el `ListView`.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: estado de dispositivo visible y editable en lista

- Mejorada UX de gestion de estado de dispositivos vinculados:
  - eliminado cambio de estado dentro del modal de edicion,
  - el estado ahora se gestiona de forma visible en cada tarjeta de dispositivo mediante `ChoiceChip`.
- El modal de edicion queda enfocado solo en renombrar dispositivo.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: ajuste UX de estado con menu desplegable

- Revertido el selector por chips para estado de dispositivo.
- Sustituido por `DropdownButtonFormField` visible dentro de cada tarjeta para un manejo mas limpio y rapido.
- Se mantiene la edicion de nombre en modal separado.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: estado de dispositivo auto-detectado

- Eliminado el control manual de estado en la lista de dispositivos.
- El estado ahora se muestra como `auto` segun contexto:
  - seleccionado + listo/grabando/sincronizando,
  - no seleccionado conectado,
  - pendientes/desconectados conservan su estado base.
- Se mantiene edicion solo para nombre y eliminacion de dispositivo.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: estado auto en chip visual

- Sustituida la caja de estado auto por un `Chip` con color semaforo para lectura rapida.
- El chip muestra `estado · auto` y cambia color segun estado detectado.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions UX: acciones movidas a menu de AppBar

- Eliminado menu de tres puntos por dispositivo dentro de la lista (sin editar nombre ni eliminar local por fila).
- El estado en chip queda limpio, sin sufijo `auto`.
- Anadido menu de tres puntos en la `AppBar` cuando esta seleccionada la pestana `Session`, con opcion unica `Eliminar`.
- La accion `Eliminar` elimina el dispositivo actualmente seleccionado.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions UX: mover `Añadir dispositivo` a AppBar

- Reubicado `Añadir dispositivo` desde el contenido de la pantalla `Session` a la `AppBar`.
- En la pestana `Session`, la `AppBar` muestra ahora:
  - icono `Añadir dispositivo`,
  - menu de tres puntos con `Eliminar`.
- El boton de anadir queda a la izquierda del menu de eliminar, como se pidio.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions UX: icono de anadir simplificado

- Cambiado el icono de `Añadir dispositivo` en AppBar a un simbolo `+` simple (`Icons.add_rounded`).
- Archivo actualizado:
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: segmented `Start` / `My Sessions`

- Anadido `SegmentedButton` en la parte superior de `Session` para separar flujos:
  - `Start`: contiene el placeholder y control actual de captura (dispositivo, control de sesion, importacion),
  - `My Sessions`: placeholder independiente para el siguiente bloque del roadmap.
- Esto desacopla el placeholder actual del siguiente placeholder de historial.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: `My Sessions` con filtros y feed de sesiones finalizadas

- Eliminada la tarjeta placeholder de `My Sessions`.
- Anadidos filtros arriba del todo para buscar y filtrar sesiones:
  - buscador por texto,
  - filtro por dispositivo,
  - orden (`Mas recientes` / `Mas antiguas`).
- Integrado feed de sesiones finalizadas en formato lista.
- Al completar una sesion en `Start Session` (sincronizacion), se crea una entrada que aparece en `My Sessions`.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: termino UX `Subir sesion` en control de captura

- Ajustado texto del flujo de sesion finalizada para alinearlo con experiencia tipo Woo Sports:
  - boton en estado pendiente pasa de `Sincronizar` a `Subir sesion`,
  - durante proceso pasa a `Subiendo...`,
  - mensajes de estado actualizados a terminologia de subida.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - My Sessions: filtros responsive en desplegables

- Ajustado layout de filtros en `My Sessions` para evitar desbordes y cortes visuales.
- Mejoras aplicadas:
  - `isExpanded: true` en desplegables,
  - textos con `ellipsis` en opciones,
  - distribucion responsive: en ancho estrecho se apilan en columna, en ancho amplio se muestran en fila.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - My Sessions: busqueda tambien por spot

- Extendida la logica de busqueda para incluir el spot ademas de titulo/resumen/dispositivo.
- En `Start Session` se anade selector de `Spot de la sesion` para etiquetar la sesion al subirla.
- El feed de `My Sessions` muestra ahora el spot en cada tarjeta de sesion.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions: reversion de busqueda por spot + dialogo al subir

- Revertido el cambio de `Spot de la sesion` en el bloque `Start Session` y la busqueda explicita por campo spot en `My Sessions`.
- Nuevo flujo al pulsar `Subir sesion` con sesion finalizada:
  - se abre un dialogo de configuracion antes de guardar,
  - permite definir `Spot` y `Resumen de sesion`.
- Al confirmar en el dialogo, la sesion se guarda/sube y aparece en el feed de `My Sessions`.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions hotfix: robustez al subir sesion desde dialogo

- Anadidos guards de `mounted` alrededor del flujo asincrono de `Subir sesion` para evitar estados invalidos al cerrar/cambiar pantalla durante el dialogo.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Hotfix estabilidad UI: callback de tab Session diferido

- Ajustados callbacks entre `SessionsPage` y `DashboardPage` para diferir actualizaciones de estado al siguiente frame (`addPostFrameCallback`).
- Objetivo: evitar conflictos de reconstruccion al cambiar sub-tab `Start Session` / `My Sessions` y acciones de AppBar.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Hotfix `Subir sesion`: dialogo sin controller local

- Ajustado el dialogo de `Subir sesion` para evitar fallo al guardar con texto en resumen.
- Cambio tecnico:
  - eliminado `TextEditingController` local del dialogo,
  - retorno directo de datos (`spot`, `notes`) desde `Navigator.pop(...)`.
- Objetivo: evitar conflictos de ciclo de vida al cerrar dialogo con teclado/foco activo.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions UX: acciones AppBar solo en `Start Session`

- Rehabilitado enlace entre sub-tab de `Session` y `Dashboard` para mostrar/ocultar acciones de AppBar segun contexto.
- En `Session`:
  - `+` y menu `Eliminar` visibles solo en `Start Session`,
  - ocultos en `My Sessions`.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Hotfix Dashboard/Sessions: callback defensivo de tab Session

- Eliminado callback post-frame inicial en `SessionsPage` para evitar cambios de estado cruzados al montar arbol de widgets.
- Endurecido callback `onStartTabChanged` en `DashboardPage` para no llamar `setState` si:
  - el widget no esta montado,
  - el valor no cambia.
- Objetivo: reducir pausas del debugger por aserciones internas al cambiar estados durante reconstruccion.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Reversion estabilidad: desacoplar callback entre Session y Dashboard

- Revertido el acoplamiento `onStartTabChanged` entre `SessionsPage` y `DashboardPage` para volver al comportamiento estable previo.
- Las acciones de AppBar de `Session` vuelven a depender solo de pestaña principal `Session` (sin depender de sub-tab interna).
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions UX: segmented fuera de tarjeta y AppBar contextual

- Reubicado el `SegmentedButton` (`Start` / `My Sessions`) fuera de la tarjeta principal, arriba del todo de la pantalla.
- Ajustado comportamiento de acciones en AppBar para `Session`:
  - `+` y menu `Eliminar` solo aparecen cuando la subpestana activa es `Start`.
  - en `My Sessions` se ocultan esas acciones al no aplicar a ese placeholder.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions UX: etiqueta de segmento renombrada

- Renombrada etiqueta del segmento de `Start` a `Start Session` para mayor claridad.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions UX: alta de dispositivo en dialogo centrado

- Sustituido el menu inferior de `Añadir dispositivo` por un dialogo centrado de configuracion.
- El nuevo flujo permite configurar desde el centro de pantalla:
  - tipo de dispositivo,
  - nombre del dispositivo,
  - accion `Vincular`.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions UX: ampliar tipos en selector (esqueleto fase 3)

- Anadidos tipos de dispositivo en el desplegable de alta:
  - `Smartwatch`
  - `Personalizado`
- Se mantiene enfoque de esqueleto/mock para fase actual; integracion real prevista para fase 3.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - Sessions UX: control core centrado y CTA principal ampliado

- Reforzada la tarjeta `Control de sesion` para destacar el flujo core de la pantalla.
- Cambios visuales:
  - contenido centrado,
  - titulo y estado mas grandes,
  - chips centrados y con iconos mas visibles,
  - boton principal en ancho completo y mayor altura para maxima visibilidad.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-22 - My Sessions: navegacion a detalle de sesion

- Anadida apertura de pantalla de detalle al pulsar una sesion del feed en `My Sessions`.
- Nueva pantalla `SessionDetailPage` con informacion base de la sesion seleccionada:
  - titulo,
  - fecha/hora,
  - dispositivo,
  - duracion,
  - resumen,
  - bloque placeholder de metricas avanzadas.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/sessions/presentation/pages/session_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).

### 2026-02-23 - Session detail: metricas mock + timeline + eventos

- Evolucionada `SessionDetailPage` para reemplazar el bloque de `Metricas (placeholder)` por contenido util de detalle.
- Nuevo bloque `Metricas de la sesion` con KPIs visuales:
  - `Distancia`
  - `Velocidad max`
  - `Tiempo en planeo`
  - `Bateria`
  - `Saltos`
- Anadida seccion `Timeline de rendimiento` con grafica custom (`CustomPainter`) y clave de test `session_timeline_chart`.
- Anadida seccion `Eventos detectados` con lista de eventos de sesion.
- Implementada generacion determinista de datos mock en `SessionDetailPage` a partir de datos base de la sesion (titulo, dispositivo, fecha, duracion) para mantener consistencia visual entre ejecuciones.
- Tests nuevos:
  - `test/features/sessions/presentation/pages/session_detail_page_test.dart`
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/session_detail_page.dart`
  - `test/features/sessions/presentation/pages/session_detail_page_test.dart`
- Verificacion ejecutada: `flutter test test/features/sessions/presentation/pages/session_detail_page_test.dart -r compact && flutter analyze && flutter test -r compact` (ok).

### 2026-02-23 - Sessions: metricas conectadas al feed + modalidad + altura de saltos

- Aplicado paso de continuidad solicitado: `SessionDetailPage` ya no calcula metricas localmente al abrirse desde datos sueltos.
- Ahora las metricas se generan al crear/subir la sesion en `SessionsPage` y viajan dentro del modelo de `My Sessions` hasta el detalle (`SessionInsightData`).
- Flujo de subida mejorado con selector de modalidad en dialogo `Configurar sesion`:
  - `Freeride`
  - `Freestyle`
  - `Big Air`
- En `My Sessions` cada tarjeta muestra tambien la modalidad junto al dispositivo y fecha.
- En `SessionDetailPage` se anade chip de modalidad y nuevo KPI clave para Big Air:
  - `Salto mas alto` (m)
- Ajuste de logica mock por modalidad:
  - rango de altura de salto mayor en `Big Air`,
  - rango intermedio en `Freestyle`,
  - rango base en `Freeride`,
  - catalogo de eventos contextual segun modalidad.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/sessions/presentation/pages/session_detail_page.dart`
  - `test/features/sessions/presentation/pages/session_detail_page_test.dart`
- Verificacion ejecutada: `flutter test test/features/sessions/presentation/pages/session_detail_page_test.dart -r compact && flutter analyze && flutter test -r compact` (ok).

### 2026-02-23 - Sessions: KPIs completos por capacidades de sensor (sin selector de modalidad)

- Ajuste de producto aplicado: se elimina la seleccion manual de modalidad al subir sesion.
- El dialogo `Configurar sesion` vuelve a centrarse en:
  - `Spot`
  - `Resumen de sesion`
- Se implementa modelo de datos de detalle orientado a sensores (`SessionInsightData`) para registrar/mostrar KPIs segun capacidades reales del dispositivo.
- `My Sessions` crea y guarda `insights` al subir sesion, derivando capacidades desde tipo de dispositivo (`kind`) vinculado.
- `SessionDetailPage` se reorganiza en bloques para mostrar los KPIs solicitados de forma completa y estructurada:
  - Core Session
  - Big Air
  - Freestyle
  - Freeride/Navegacion
  - Saltos
  - Control tecnico
  - Condiciones meteo-contexto
  - Seguridad y riesgo
  - Dispositivo y calidad de datos
  - Social/Competicion
  - KPIs compuestos
- Cada KPI se muestra con valor cuando el sensor lo soporta; si no, aparece como `No disponible en este dispositivo`.
- Se mantiene KPI destacado `Salto mas alto` en el resumen principal de metricas.
- Se mantiene `Timeline de rendimiento` solo cuando hay datos de velocidad disponibles.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/sessions/presentation/pages/session_detail_page.dart`
  - `test/features/sessions/presentation/pages/session_detail_page_test.dart`
  - `SESSION_TRACKER.md`

### 2026-02-23 - Sessions: panel de capacidades de dispositivo en Start Session

- Implementado siguiente paso UX en `Start Session`: panel `Capacidades del dispositivo` para el wearable seleccionado.
- El panel muestra:
  - ratio de sensores disponibles (`X/9`),
  - chips por capacidad (`GPS`, `Velocidad`, `Movimiento`, `Altitud`, `Ritmo cardiaco`, `Barometro`, `Bateria`, `Conectividad`, `Meteo`),
  - estado visual disponible/no disponible para cada capacidad.
- El contenido se actualiza al cambiar de dispositivo en la lista vinculada.
- Se reutiliza y expone el mapeo de capacidades desde `SessionInsightData` para mantener una unica fuente de verdad.
- Test nuevo para validar comportamiento:
  - `test/features/sessions/presentation/pages/sessions_page_test.dart`
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/sessions/presentation/pages/session_detail_page.dart`
  - `test/features/sessions/presentation/pages/sessions_page_test.dart`
- Verificacion ejecutada: `flutter test test/features/sessions/presentation/pages/sessions_page_test.dart -r compact && flutter analyze && flutter test -r compact` (ok).

### 2026-02-23 - Sessions: incluir telefono como dispositivo seleccionable por defecto

- Anadido `Telefono del usuario` a la lista inicial de dispositivos vinculados para evitar bloqueo de grabacion cuando no hay wearable externo.
- El telefono queda disponible como fuente valida de captura igual que el resto de dispositivos seleccionables.
- Test anadido para asegurar presencia del telefono en la lista de dispositivos.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `test/features/sessions/presentation/pages/sessions_page_test.dart`
- Verificacion ejecutada: `flutter test test/features/sessions/presentation/pages/sessions_page_test.dart -r compact && flutter analyze && flutter test -r compact` (ok).

### 2026-02-23 - Sessions: telefono siempre visible y re-seleccionable

- Corregido el flujo para que el `Telefono del usuario` permanezca siempre disponible en la lista de dispositivos.
- El telefono ahora se prioriza visualmente al inicio de la lista para facilitar volver a seleccionarlo tras usar un wearable externo.
- Se bloquea su eliminacion para evitar quedarse sin opcion local de captura.
- Se anade prueba para validar que el telefono aparece en lista y queda por encima de otros dispositivos.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `test/features/sessions/presentation/pages/sessions_page_test.dart`
- Verificacion ejecutada: `flutter test test/features/sessions/presentation/pages/sessions_page_test.dart -r compact && flutter analyze && flutter test -r compact` (ok).

### 2026-02-23 - Sessions: auto-seleccion de telefono cuando no hay dispositivo activo

- Anadida logica de fallback para seleccionar automaticamente `Telefono del usuario` cuando no exista dispositivo seleccionado valido.
- El fallback se ejecuta al iniciar la pantalla y tambien tras eliminar el dispositivo activo.
- Si no existiera telefono por algun estado inconsistente, se conserva fallback al primer dispositivo disponible o `null` si la lista esta vacia.
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Verificacion ejecutada: `flutter analyze && flutter test test/features/sessions/presentation/pages/sessions_page_test.dart -r compact` (ok).

### 2026-02-23 - Session detail UX: foco en saltos + historico detallado

- Redisenada la parte principal del detalle para priorizar los KPIs que realmente se consultan al terminar sesion:
  - `Salto mas alto`
  - `Saltos`
  - `Hangtime maximo`
  - `Duracion sesion`
  - `Velocidad max`
- Eliminados KPIs del bloque `Social / Competicion` segun preferencia de producto.
- Anadida seccion `Historico de saltos` con filas por salto mostrando:
  - numero de salto,
  - altura,
  - hangtime,
  - velocidad de caida,
  - minuto y segundo exacto del salto.
- Anadido modelo `SessionJumpRecord` y generacion determinista de historico de saltos para sesiones mock.
- Se mantiene timeline y eventos, pero con jerarquia visual orientada al resumen post-sesion.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/session_detail_page.dart`
  - `test/features/sessions/presentation/pages/session_detail_page_test.dart`
- Verificacion ejecutada: `flutter test test/features/sessions/presentation/pages/session_detail_page_test.dart -r compact && flutter analyze && flutter test -r compact` (ok).

### 2026-02-23 - Integracion inicial de historico de saltos desde import de archivo

- Implementada primera conexion del historico de saltos a una ruta de datos tipo sensor en el flujo `Importar sesion`.
- `Importar sesion` ya no muestra solo aviso: ahora crea una sesion en `My Sessions` con:
  - metadatos de sesion importada,
  - historico de saltos estructurado (`SessionJumpRecord`),
  - recalculo de KPIs clave de salto en detalle (`jumpsCount`, `maxJumpHeightMeters`, `maxHangtimeSeconds`) a partir de los registros importados.
- Anadido `copyWith` en `SessionInsightData` para permitir sobreescritura de KPIs desde payload importado sin romper el resto de metricas.
- Anadido test de flujo para validar importacion y navegacion a detalle con presencia de `Historico de saltos`.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
  - `lib/features/sessions/presentation/pages/session_detail_page.dart`
  - `test/features/sessions/presentation/pages/sessions_page_test.dart`
- Verificacion ejecutada: `flutter test test/features/sessions/presentation/pages/sessions_page_test.dart -r compact && flutter analyze && flutter test -r compact` (ok).

### 2026-02-23 - Session detail: selector de mediciones para evitar scroll excesivo

- Reintroducida la informacion avanzada de KPIs debajo de `Eventos detectados`, pero con UX de seleccion para no alargar excesivamente la pantalla.
- `SessionDetailPage` pasa a `StatefulWidget` y anade bloque `Mediciones avanzadas` con `ChoiceChip` por familia de metricas.
- Solo se muestra en detalle la familia elegida por el usuario (p.ej. `Core Session`, `Big Air`, `Freestyle`, etc.), manteniendo acceso a todas las mediciones disponibles sin saturar la vista.
- Se mantiene eliminado el bloque `Social / Competicion` segun decision previa.
- Archivos actualizados:
  - `lib/features/sessions/presentation/pages/session_detail_page.dart`
  - `test/features/sessions/presentation/pages/session_detail_page_test.dart`
- Verificacion ejecutada: `flutter test test/features/sessions/presentation/pages/session_detail_page_test.dart -r compact && flutter analyze && flutter test -r compact` (ok).

### 2026-02-23 - Session detail: ajustes de labels de KPIs para mejor comprension

- Revision y mejora de labels de KPIs para que sean mas intuitivos para el usuario:
  - `Velocidad p95` -> `Top velocidad estable`
  - `Hangtime p95` -> `Top hangtime estable`
  - `Progreso por trick (+X% vs 30d)` -> `Mejora ultimos 30 dias: +X%`
  - `Consistencia de alturas` -> `Variacion de alturas`
  - `VMG upwind` -> `Velocidad efectiva upwind`
  - `VMG downwind` -> `Velocidad efectiva downwind`
  - `Distribucion de alturas` -> formato en 2 lineas: `Tipica: Xm` / `Maxima habitual: Xm`
  - `Landing speed` -> `Fuerza G al aterrizar` (en G en lugar de kt)
  - `Calidad de jibe` -> `Calidad del giro downwind`
- Archivo actualizado:
  - `lib/features/sessions/presentation/pages/session_detail_page.dart`
- Verificacion ejecutada: `flutter analyze` (ok).
