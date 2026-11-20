

<!-- local-development:start -->
# Desarrollo local

Puedes abrir este repositorio en VS Code, Antigravity o Sublime Text. El compilador y los servicios necesarios dependen del componente indicado abajo.

## Ruby / Rails

Usa la versión de Ruby y el Gemfile de cada aplicación en WSL o Linux. Crea una base de datos local y ejecuta sus pruebas antes de iniciarla. El editor de Windows no aporta el runtime Ruby.

## Componentes y validación

Inventario y compilaciones locales del 2026-11-15. Una compilación correcta no acredita todavía interacción, compatibilidad de base de datos, instalador ni despliegue.

| Componente | Tipo / destino | Validación |
| --- | --- | --- |
| [ruby-master/Gemfile](<ruby-master/Gemfile>) | ruby | Sin ejecutar |

## Archivos ignorados

`.gitignore` excluye credenciales locales, estado del editor y salidas de las herramientas detectadas. No deja de versionar archivos que ya estaban en Git. Los manifiestos, archivos de bloqueo, recursos fuente y scripts de esquema forman parte del código.
<!-- local-development:end -->


<!-- improvements-20261119:start -->
## Mejoras y verificación — 2026-11-19 (Reparación de métodos privados duplicados, autorización CRUD y credenciales por entorno (Rails))

- **Cambios:** Corregida la redefinición privada de `publish!`, `like!` y `dislike!` en `Video` (evitando `NoMethodError` y likes negativos/`nil`), completados `update`/`destroy` y verificación de propietario (`authorize_owner!`) + asociación `current_user` en `VideosController`, protegida la ruta `/sidekiq` con `authenticate :user`, eliminadas credenciales fijas en `config/database.yml` y guardada la inicialización de PubNub sin claves.
- **Validación:** WSL Ruby 3.2.3 `ruby -c` (39/39 archivos `.rb`) + 7/7 pruebas unitarias sobre `User` y `Video`.
<!-- improvements-20261119:end -->
