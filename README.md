# 📖 Neovim Shortcuts & Commands Guide (Personal Configuration)

Guía completa de atajos de teclado, comandos de plugins y comandos útiles nativos de Neovim configurados en este entorno.

> **Leader Key:** `<Space>` | **LocalLeader:** `\`

---

## 📑 Índice

1. [📂 Navegación de Archivos y Directorios (Oil & Projects)](#1--navegación-de-archivos-y-directorios)
2. [📋 Portapapeles del Sistema (Clipboard)](#2--portapapeles-del-sistema)
3. [🪟 Gestión de Ventanas (Splits & Maximizer)](#3--gestión-de-ventanas-splits--maximizer)
4. [🗂️ Gestión de Pestañas y Búferes (Tabs & Bufferline)](#4--gestión-de-pestañas-y-búferes)
5. [💾 Gestión de Sesiones (Auto-Session)](#5--gestión-de-sesiones-auto-session)
6. [🔍 Búsqueda Rápida (FZF-Lua)](#6--búsqueda-rápida-fzf-lua)
7. [🧠 LSP (Language Server Protocol)](#7--lsp-language-server-protocol)
8. [🩺 Diagnósticos y Formateo de Código (Conform & Diagnostics)](#8--diagnósticos-y-formateo-de-código)
9. [🌳 Treesitter (Selección Incremental y Textobjects)](#9--treesitter-selección-incremental-y-textobjects)
10. [✨ Autocompletado (Blink.cmp)](#10--autocompletado-blinkcmp)
11. [🐞 Depurador (DAP - Debug Adapter Protocol)](#11--depurador-dap)
12. [🗨️ Comentarios (Comment.nvim)](#12--comentarios-commentnvim)
13. [📝 Tareas y Recordatorios (Todo-Comments)](#13--tareas-y-recordatorios-todo-comments)
14. [📄 Markdown (Tree-sitter & Render)](#14--markdown-tree-sitter--render)
15. [🎓 Utilidades 42 School & Compilación C](#15--utilidades-42-school--compilación-c)
16. [❓ Ayuda de Atajos y HUD (Which-Key & Showkeys)](#16--ayuda-de-atajos-y-hud)
17. [⚡ Comandos de Mantenimiento de Plugins (Lazy & Mason)](#17--comandos-de-mantenimiento-de-plugins)
18. [💡 Atajos y Comandos Nativos Útiles de Neovim (Cheat Sheet)](#18--atajos-y-comandos-nativos-útiles-de-neovim)

---

## 1. 📂 Navegación de Archivos y Directorios

Administración de archivos tipo buffer flotante mediante **Oil.nvim**.

| Modo    | Atajo / Comando | Descripción                                                |
| :------ | :-------------- | :--------------------------------------------------------- |
| Normal  | `-`             | Abrir directorio padre en ventana flotante con Oil         |
| Normal  | `<leader>-`     | Abrir directorio padre en ventana flotante con Oil (alias) |
| Comando | `:Oil`          | Abre el explorador Oil en el buffer actual                 |
| Comando | `:Oil --float`  | Abre el explorador Oil en ventana flotante                 |

### Controles dentro del buffer de Oil:

- `<CR>`: Abrir archivo o entrar a directorio seleccionado.
- `-`: Subir un nivel al directorio padre.
- `g?`: Ver panel de ayuda con todos los comandos de Oil.
- `<C-p>`: Previsualizar archivo bajo el cursor.
- `<C-c>` / `q`: Cerrar explorador Oil.
- `<C-l>`: Refrescar vista del directorio.

---

## 2. 📋 Portapapeles del Sistema

Interacción directa con el portapapeles del sistema operativo (`+` register) sin sobreescribir los registros internos de Neovim.

| Modo            | Atajo       | Acción                                                                   |
| :-------------- | :---------- | :----------------------------------------------------------------------- |
| Normal / Visual | `<leader>y` | Copiar (_yank_) la selección o movimiento al portapapeles del sistema    |
| Normal / Visual | `<leader>Y` | Copiar la línea completa al portapapeles del sistema                     |
| Normal / Visual | `<leader>d` | Cortar / borrar selección o movimiento hacia el portapapeles del sistema |
| Normal / Visual | `<leader>D` | Cortar la línea completa hacia el portapapeles del sistema               |
| Normal          | `<leader>p` | Pegar contenido del portapapeles del sistema después del cursor          |
| Normal          | `<leader>P` | Pegar contenido del portapapeles del sistema antes del cursor            |

### Escape rápido:

| Modo   | Atajo | Acción                             |
| :----- | :---- | :--------------------------------- |
| Insert | `jk`  | Salir inmediatamente a Modo Normal |

---

## 3. 🪟 Gestión de Ventanas (Splits & Maximizer)

Creación, navegación, redimensionamiento y maximización de divisiones.

| Modo   | Atajo        | Descripción                                                  |
| :----- | :----------- | :----------------------------------------------------------- |
| Normal | `<leader>sv` | Dividir ventana verticalmente (`:vsplit`)                    |
| Normal | `<leader>sh` | Dividir ventana horizontalmente (`:split`)                   |
| Normal | `<leader>se` | Igualar tamaño de todas las ventanas (`<C-w>=`)              |
| Normal | `<leader>sx` | Cerrar la ventana o división actual (`:close`)               |
| Normal | `<leader>sm` | **Maximizar / Restaurar** la división actual (Vim-Maximizer) |
| Normal | `<leader>sr` | Restaurar divisiones a tamaños iguales                       |

### Movimiento rápido entre divisiones (con tecla `s`):

| Modo   | Atajo     | Navegación                                    |
| :----- | :-------- | :-------------------------------------------- |
| Normal | `s` + `←` | Mover foco a la división izquierda (`<C-w>h`) |
| Normal | `s` + `↓` | Mover foco a la división inferior (`<C-w>j`)  |
| Normal | `s` + `↑` | Mover foco a la división superior (`<C-w>k`)  |
| Normal | `s` + `→` | Mover foco a la división derecha (`<C-w>l`)   |

---

## 4. 🗂️ Gestión de Pestañas y Búferes

Administración visual de pestañas gestionada con **Bufferline.nvim**.

| Modo   | Atajo / Comando | Descripción                                                      |
| :----- | :-------------- | :--------------------------------------------------------------- |
| Normal | `<leader>to`    | Abrir una nueva pestaña (`:tabnew`)                              |
| Normal | `<leader>tx`    | Cerrar la pestaña actual (`:tabclose`)                           |
| Normal | `<leader>tn`    | Ir a la siguiente pestaña (`:tabnext`)                           |
| Normal | `<leader>tp`    | Ir a la pestaña anterior (`:tabprevious`)                        |
| Normal | `<leader>tf`    | Abrir el archivo/búfer actual en una nueva pestaña independiente |
| Normal | `gt` / `gT`     | Navegar a la pestaña siguiente / anterior (nativo)               |
| Normal | `{i}gt`         | Ir directamente a la pestaña número `{i}` (ej. `2gt`)            |

---

## 5. 💾 Gestión de Sesiones (Módulo Nativo en Lua)

Guarda y restaura el estado de tus pestañas, buffers y ventanas por proyecto usando las APIs nativas de Neovim y menú interactivo de selección.

| Modo    | Atajo        | Comando                  | Descripción                                   |
| :------ | :----------- | :----------------------- | :-------------------------------------------- |
| Normal  | `<leader>wr` | `:SessionRestore`        | Menú interactivo para seleccionar y restaurar |
| Normal  | `<leader>ws` | `:SessionSave`           | Guardar sesión del proyecto actual            |
| Normal  | `<leader>wa` | `:SessionToggleAutoSave` | Activar / desactivar autoguardado de sesión   |
| Comando | —            | `:SessionRestore [nom]`  | Restaura una sesión específica por nombre     |
| Comando | —            | `:SessionDelete`         | Elimina una sesión guardada                   |

---

## 6. 🔍 Búsqueda Rápida (FZF-Lua)

Búsqueda difusa ultrarrápida impulsada por `fzf-lua` y `fd`.

| Modo   | Atajo              | Función / Descripción                                             |
| :----- | :----------------- | :---------------------------------------------------------------- |
| Normal | `<leader>ff`       | Buscar archivos en el proyecto actual (`fd` con archivos ocultos) |
| Normal | `<leader>fg`       | Búsqueda de texto en vivo en todo el proyecto (_live grep_)       |
| Normal | `<leader>fc`       | Buscar dentro de los archivos de configuración de Neovim          |
| Normal | `<leader>fo`       | Buscar entre archivos abiertos recientemente (_old files_)        |
| Normal | `<leader><leader>` | Buscar y cambiar entre búferes activos                            |
| Normal | `<leader>/`        | Búsqueda difusa (_live grep_) dentro del búfer actual             |
| Normal | `<leader>fw`       | Buscar la palabra bajo el cursor (_cword_) en el proyecto         |
| Normal | `<leader>fW`       | Buscar la palabra estricta bajo el cursor (_cWORD_)               |
| Normal | `<leader>fd`       | Ver diagnósticos y errores del documento actual                   |
| Normal | `<leader>fh`       | Buscar temas de ayuda de Neovim (_helptags_)                      |
| Normal | `<leader>fk`       | Explorar todos los atajos de teclado registrados (_keymaps_)      |
| Normal | `<leader>fb`       | Explorar todos los selectores disponibles en FZF-Lua (_builtin_)  |
| Normal | `<leader>fr`       | Reanudar la última búsqueda realizada en FZF (_resume_)           |

---

## 7. 🧠 LSP (Language Server Protocol)

Inteligencia de código (definiciones, referencias, renombrado, acciones de código y sugerencias).

| Modo            | Atajo         | Acción                                                              |
| :-------------- | :------------ | :------------------------------------------------------------------ |
| Normal          | `gd`          | Ir a la definición (_Goto Definition_, vía FZF-Lua)                 |
| Normal          | `gD`          | Ir a la declaración (_Goto Declaration_, ej. cabecera `.h` en C)    |
| Normal          | `gr`          | Buscar todas las referencias del símbolo (_Goto References_)        |
| Normal          | `gI`          | Ir a la implementación (_Goto Implementation_)                      |
| Normal          | `<leader>D`   | Ver definición del tipo de dato (_Type Definition_)                 |
| Normal          | `<leader>ds`  | Explorar símbolos del documento actual (_Document Symbols_)         |
| Normal          | `<leader>wss` | Buscar símbolos en todo el espacio de trabajo (_Workspace Symbols_) |
| Normal          | `<leader>cr`  | Renombrar variable o función en todo el proyecto (_Rename_)         |
| Normal / Visual | `<leader>ca`  | Ejecutar acción de código (_Code Action_ o corrección sugerida)     |
| Normal          | `<leader>th`  | Alternar visualización de pistas de tipos (_Toggle Inlay Hints_)    |
| Normal          | `K`           | Mostrar documentación / hover del símbolo bajo el cursor            |
| Normal          | `<C-k>`       | Mostrar información de firma de función (_Signature Help_)          |

### Servidores LSP configurados:

- `clangd` (C / C++)
- `lua_ls` (Lua)
- `ts_ls` (TypeScript / JavaScript)
- `marksman` (Markdown)
- `bashls` (Bash / Shell)
- `tailwindcss` (Tailwind CSS)
- `mypy` (Python type checker)

---

## 8. 🩺 Diagnósticos y Formateo de Código

Gestión de errores sintácticos y formateo unificado con **Conform.nvim**.

| Modo   | Atajo        | Acción                                                         |
| :----- | :----------- | :------------------------------------------------------------- |
| Normal | `gl`         | Abrir diagnóstico/error flotante detallado en la línea actual  |
| Normal | `<leader>cf` | Formatear el archivo actual (mediante Conform, fallback a LSP) |
| Normal | `[d`         | Saltar al diagnóstico/error anterior                           |
| Normal | `]d`         | Saltar al diagnóstico/error siguiente                          |

### Formateadores configurados en Conform:

- **Lua:** `stylua`
- **JavaScript / TypeScript:** `prettierd`, `prettier`
- **Python:** `isort`, `black`
- **Rust:** `rustfmt`

---

## 9. 🌳 Treesitter (Selección Incremental y Textobjects)

Navegación y manipulación de código basada en el árbol sintáctico.

### Selección Incremental:

| Modo            | Atajo         | Acción                                                              |
| :-------------- | :------------ | :------------------------------------------------------------------ |
| Normal / Visual | `<Enter>`     | Iniciar selección / expandir selección al siguiente nodo sintáctico |
| Visual          | `<Backspace>` | Reducir selección al nodo sintáctico previo                         |

### Objetos de texto (Text Objects) en modo Operador / Visual:

Úsalos tras un operador como `v` (seleccionar), `d` (borrar), `c` (cambiar), `y` (copiar):

| Atajo | Significado       | Descripción                                             |
| :---- | :---------------- | :------------------------------------------------------ |
| `af`  | _Around Function_ | Selecciona toda la función (incluyendo encabezado)      |
| `if`  | _Inside Function_ | Selecciona el cuerpo interno de la función              |
| `ac`  | _Around Class_    | Selecciona toda la clase / struct                       |
| `ic`  | _Inside Class_    | Selecciona el contenido interno de la clase             |
| `ao`  | _Around Comment_  | Selecciona todo el comentario                           |
| `as`  | _Around Scope_    | Selecciona el alcance lingüístico local (_local scope_) |

### Intercambio de Parámetros (Swap):

| Modo   | Atajo       | Acción                                             |
| :----- | :---------- | :------------------------------------------------- |
| Normal | `<leader>a` | Intercambiar parámetro actual con el **siguiente** |
| Normal | `<leader>A` | Intercambiar parámetro actual con el **anterior**  |

---

## 10. ✨ Autocompletado (Blink.cmp)

Motor de autocompletado nativo ultra rápido escrito en Rust (`blink.cmp`).

| Modo   | Atajo         | Acción                                                      |
| :----- | :------------ | :---------------------------------------------------------- |
| Insert | `<Enter>`     | Confirmar y aceptar la sugerencia seleccionada              |
| Insert | `<C-Space>`   | Abrir menú de autocompletado o abrir documentación del item |
| Insert | `<C-n>` / `↓` | Seleccionar siguiente elemento de la lista                  |
| Insert | `<C-p>` / `↑` | Seleccionar elemento anterior de la lista                   |
| Insert | `<C-e>`       | Cerrar / ocultar el menú de sugerencias                     |
| Insert | `<C-k>`       | Alternar ayuda de firma de función (_Signature Help_)       |

> **Tip:** En archivos Markdown y mensajes de commit de Git, se autocompletan emojis automáticamente escribiendo `:nombre_emoji:`.

---

## 11. 🐞 Depurador (DAP)

Depuración interactiva con **nvim-dap**, **nvim-dap-ui** y soporte para C/C++ vía `cppdbg`.

| Modo   | Atajo        | Acción                                                     |
| :----- | :----------- | :--------------------------------------------------------- |
| Normal | `<leader>dt` | Poner / quitar punto de interrupción (_Toggle Breakpoint_) |
| Normal | `<leader>dc` | Iniciar / continuar ejecución (_Continue_)                 |
| Normal | `<leader>di` | Paso adentro (_Step Into_)                                 |
| Normal | `<leader>do` | Paso encima / siguiente línea (_Step Over_)                |
| Normal | `<leader>du` | Paso afuera de la función (_Step Out_)                     |
| Normal | `<leader>dr` | Abrir consola REPL de depuración                           |
| Normal | `<leader>dl` | Re-ejecutar la última sesión de depuración (_Run Last_)    |
| Normal | `<leader>dq` | Detener y terminar depuración (_Terminate_ y cierra UI)    |
| Normal | `<leader>db` | Listar todos los puntos de interrupción activos            |
| Normal | `<leader>de` | Activar detención en excepciones                           |

---

## 12. 🗨️ Comentarios (Nativo Neovim 0.10+ en Lua)

Comentado rápido y eficiente nativo integrado sin plugins externos, con soporte para múltiples lenguajes (C, C++, Lua, Python, JS/TS, TSX, HTML, CSS, SQL, etc.).

| Modo   | Atajo        | Acción                                                              |
| :----- | :----------- | :------------------------------------------------------------------ |
| Normal | `gcc`        | Comentar / descomentar la línea actual                              |
| Normal | `gbc`        | Comentar / descomentar bloque en la línea actual                    |
| Normal | `gc{motion}` | Comentar un movimiento (ej. `gcw` para comentar palabra)            |
| Normal | `gb{motion}` | Comentar bloque según movimiento                                    |
| Normal | `gco`        | Insertar comentario en la siguiente línea e ingresar en modo Insert |
| Normal | `gcO`        | Insertar comentario en la línea anterior e ingresar en modo Insert  |
| Normal | `gcA`        | Insertar comentario al final de la línea actual                     |
| Visual | `gc`         | Comentar / descomentar las líneas seleccionadas                     |
| Visual | `gb`         | Comentar / descomentar selección en formato bloque                  |

---

## 13. 📝 Tareas y Recordatorios (Todo-Comments)

Resaltado de comentarios especiales como `TODO:`, `FIXME:`, `NOTE:`, `WARN:`, `HACK:`, `PERF:`.

| Modo    | Atajo           | Acción                                       |
| :------ | :-------------- | :------------------------------------------- |
| Normal  | `]t`            | Saltar al **siguiente** comentario de tarea  |
| Normal  | `[t`            | Saltar al **anterior** comentario de tarea   |
| Comando | `:TodoQuickFix` | Listar todos los TODOs en la lista quickfix  |
| Comando | `:TodoLocList`  | Listar los TODOs en la lista de localización |

---

## 14. 📄 Markdown (Tree-sitter & Render)

Configuración avanzada de Markdown impulsada por **[tree-sitter-markdown](https://github.com/tree-sitter-grammars/tree-sitter-markdown)** y visualización enriquecida en búfer con **render-markdown.nvim**.

| Modo              | Atajo        | Acción                                                                 |
| :---------------- | :----------- | :--------------------------------------------------------------------- |
| Normal (en `.md`) | `<leader>tm` | **Alternar renderizado visual enriquecido** (_Toggle Markdown Render_) |

### Comandos personalizados:

- `:MarkdownToggle` → Activa / desactiva la vista enriquecida (tablas formateadas, cajas de código estilizadas, íconos de títulos, checkbox interactivo).
- `:MarkdownPreview` → Alias para activar/desactivar la previsualización interactiva.
- `:MarkdownInstall` → Instala o compila de inmediato las gramáticas oficiales (`markdown` y `markdown_inline`).
- `:MarkdownUpdate` → Actualiza las gramáticas de Tree-sitter de Markdown.

---

## 15. 🎓 Utilidades 42 School & Compilación C

Herramientas diseñadas para proyectos de la escuela 42 (norminette, cabecera institucional y compilación rápida).

| Modo   | Atajo       | Comando       | Descripción                                                        |
| :----- | :---------- | :------------ | :----------------------------------------------------------------- |
| Normal | `<F1>`      | `:Stdheader`  | Inserta o actualiza la cabecera estándar de 42                     |
| Normal | `<F5>`      | `:Norminette` | Ejecuta la verificación de `norminette` y muestra diagnósticos     |
| Normal | `<C-f>`     | `:Format`     | Formatea el archivo actual según las normas de 42                  |
| Normal | `<leader>m` | `:CompileC`   | Compila el archivo `.c` actual con `gcc -g` en el mismo directorio |

---

## 16. ❓ Ayuda de Atajos y HUD

Visualizadores interactivos para aprender y recordar combinaciones.

| Modo    | Atajo / Comando   | Descripción                                                                |
| :------ | :---------------- | :------------------------------------------------------------------------- |
| Normal  | `<leader>?`       | Despliega panel emergente con los atajos locales del búfer (**Which-Key**) |
| Comando | `:ShowkeysToggle` | Muestra / oculta el HUD flotante con las últimas teclas pulsadas           |

---

## 17. ⚡ Comandos de Mantenimiento de Plugins

Comandos esenciales para gestionar paquetes, lenguajes y diagnósticos de Neovim.

| Comando             | Descripción                                                           |
| :------------------ | :-------------------------------------------------------------------- |
| `:Lazy`             | Abre el administrador visual de plugins (**Lazy.nvim**)               |
| `:Lazy update`      | Actualiza todos los plugins instalados                                |
| `:Lazy clean`       | Elimina plugins que ya no están en la configuración                   |
| `:Lazy sync`        | Sincroniza e instala dependencias faltantes                           |
| `:Mason`            | Abre el gestor visual de LSPs, linters, debuggers y formateadores     |
| `:TSInstall <lang>` | Instala el parser de Treesitter para un lenguaje (ej. `:TSInstall c`) |
| `:TSUpdate`         | Actualiza todos los parsers de Treesitter instalados                  |
| `:checkhealth`      | Diagnóstico general del estado y dependencias de Neovim y plugins     |
| `:messages`         | Muestra el registro histórico de avisos y errores de Neovim           |

---

## 18. 💡 Atajos y Comandos Nativos Útiles de Neovim

Una selección de los comandos y movimientos más potentes de Neovim para potenciar tu flujo diario:

### Movimientos y Navegación Rápida

- `w` / `b` : Avanzar / retroceder una palabra.
- `e` / `ge` : Ir al final de la palabra siguiente / anterior.
- `0` / `^` / `$` : Principio de línea / primer carácter no blanco / fin de línea.
- `f{char}` / `F{char}` : Saltar hacia adelante / atrás hasta el carácter `{char}` en la línea.
- `;` / `,` : Repetir el salto de `f` hacia adelante / atrás.
- `gg` / `G` : Ir a la primera línea / última línea del archivo.
- `{num}G` o `:{num}` : Saltar directamente a la línea `{num}` (ej. `42G`).
- `{` / `}` : Saltar al párrafo anterior / siguiente.
- `%` : Saltar entre paréntesis, llaves o corchetes correspondientes.
- `*` / `#` : Buscar la palabra bajo el cursor hacia adelante / atrás.

### Lista de Saltos y Marcas (Jump List)

- `<C-o>` : Regresar a la posición anterior en el historial de saltos.
- `<C-i>` : Avanzar a la posición siguiente en el historial de saltos.
- `m{a-z}` : Crear una marca local con la letra `{a-z}` (ej. `ma`).
- `'{a-z}` : Saltar a la línea de la marca `{a-z}` (ej. `'a`).
- `''` : Volver a la última posición previa al último salto grande.

### Edición Eficiente & Operadores

- `.` : **Repite la última acción de edición** (el comando más potente de Vim).
- `ciw` : _Change Inside Word_ (borra la palabra actual y entra en modo Insert).
- `diw` / `yiw` : Borrar palabra / copiar palabra.
- `ci"` / `ci'` / `ci(` / `ci{` : Cambiar el contenido dentro de comillas o paréntesis.
- `ca"` / `ca(` : Cambiar dentro e incluyendo las comillas o paréntesis.
- `C` / `D` : Cambiar / borrar desde el cursor hasta el final de la línea.
- `s` : Borrar carácter actual e ingresar a Insert.
- `S` : Borrar toda la línea actual e ingresar a Insert.
- `J` : Unir la línea siguiente con la actual eliminando el salto de línea.
- `u` / `<C-r>` : Deshacer (_undo_) / Rehacer (_redo_).

### Selección en Bloque (Visual Block)

- `<C-v>` : Entrar en modo Bloque Visual.
- Con el bloque seleccionado:
  - Presiona `I` (mayúscula), escribe el texto a insertar (ej. `// `), y pulsa `<Esc>`: el texto se duplicará en todas las líneas del bloque.
  - Presiona `d` o `c` para borrar o cambiar columnas de texto.

### Búsqueda y Reemplazo

- `:%s/buscar/reemplazar/g` : Reemplaza todas las apariciones en todo el archivo.
- `:%s/buscar/reemplazar/gc` : Reemplaza pidiendo confirmación en cada caso.
- `:s/buscar/reemplazar/g` : Reemplaza solo en la línea actual.
- `:noh` : Limpia el resaltado de la última búsqueda (`no highlight`).

### Ventanas y Búferes Nativos

- `:w` / `:q` / `:wq` : Guardar / salir / guardar y salir.
- `:wa` / `:qa` : Guardar todos / salir de todas las ventanas.
- `:q!` : Forzar salida descartando cambios no guardados.
- `:bnext` / `:bprev` : Ir al búfer siguiente / anterior.
- `:bdelete` / `:bd` : Cerrar el búfer actual sin cerrar la división.
- `<C-w>h` / `j` / `k` / `l` : Moverse entre ventanas divididas.
- `<C-w>=` : Igualar el tamaño de todas las divisiones.
- `<C-w>_` / `<C-w>|` : Maximizar altura / anchura de la ventana actual.
