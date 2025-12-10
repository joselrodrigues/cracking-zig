# Cracking Zig CLI - Plan de Desarrollo

## Visión General

Crear un CLI interactivo para practicar problemas de algoritmos en Zig con tracking de progreso, integración con editores, y una experiencia de usuario fluida.

---

## Objetivos del MVP

### Features Core
1. **`cz list`** - Listar todos los problemas con estado (completado/pendiente)
2. **`cz start <problem>`** - Abrir problema en editor con split (README + código)
3. **`cz test`** - Ejecutar tests del problema actual
4. **Progress Tracking** - Guardar progreso en `~/.cracking-zig/progress.json`

### Non-Goals del MVP
- TUI interactivo (viene después)
- Hints system
- Stats/analytics
- Spaced repetition

---

## Arquitectura

### Estructura de Directorios

```
cracking-zig/
├── problems/                    # Problemas existentes
│   ├── two-pointers/
│   ├── sliding-window/
│   └── ...
├── cli/                         # Código del CLI
│   ├── build.zig
│   └── src/
│       ├── main.zig            # Entry point, arg parsing
│       ├── commands/
│       │   ├── list.zig        # Comando: listar problemas
│       │   ├── start.zig       # Comando: abrir en editor
│       │   └── test.zig        # Comando: ejecutar tests
│       ├── core/
│       │   ├── problem.zig     # Struct Problem, scanning
│       │   ├── progress.zig    # Read/write progress.json
│       │   └── config.zig      # User config (editor, paths)
│       └── utils/
│           ├── editor.zig      # Detectar y abrir editor
│           └── fs.zig          # File system helpers
├── CLI_PLAN.md                  # Este archivo
└── CLAUDE.md                    # Project guidelines
```

### Estructuras de Datos Principales

```zig
// Problem representa un problema individual
const Problem = struct {
    id: []const u8,           // "two-pointers/easy/01_pair_sum"
    pattern: []const u8,      // "two-pointers"
    difficulty: Difficulty,   // .easy, .medium, .hard
    number: u8,               // 1, 2, 3...
    name: []const u8,         // "pair_sum"
    path: []const u8,         // Full path al directorio
    status: ProblemStatus,    // del progress.json
};

const ProblemStatus = enum {
    not_started,
    in_progress,
    completed,
};

const Difficulty = enum {
    easy,
    medium,
    hard,
};
```

### Progress File Format

**Location:** `~/.cracking-zig/progress.json`

```json
{
  "version": "1.0",
  "problems": {
    "two-pointers/easy/01_pair_sum": {
      "status": "completed",
      "last_attempt": "2025-01-15T10:30:00Z",
      "attempts": 3,
      "notes": ""
    },
    "two-pointers/medium/01_longest_palindrome": {
      "status": "in_progress",
      "last_attempt": "2025-01-16T14:20:00Z",
      "attempts": 1,
      "notes": "Working on expand logic"
    }
  }
}
```

---

## Roadmap de Desarrollo

### Fase 1: Setup Básico (Semana 1)

#### 1.1 Estructura del Proyecto
- [ ] Crear directorio `cli/`
- [ ] Setup `cli/build.zig`
- [ ] Crear estructura de src/ con archivos vacíos
- [ ] Verificar compilación básica

#### 1.2 Scanning de Problemas
- [ ] Implementar `problem.zig`: escanear directorio `problems/`
- [ ] Parsear estructura: pattern/difficulty/number/name
- [ ] Validar que cada problema tiene README, .zig, _test.zig
- [ ] Tests para scanner

#### 1.3 Progress System
- [ ] Implementar `progress.zig`: leer/escribir JSON
- [ ] Crear directorio `~/.cracking-zig/` si no existe
- [ ] Manejar progress.json (crear si no existe)
- [ ] API: getStatus(), setStatus(), listAll()
- [ ] Tests para progress system

### Fase 2: Comandos Básicos (Semana 2)

#### 2.1 Comando `list`
- [ ] Implementar arg parsing en main.zig
- [ ] `cz list` - mostrar todos los problemas
- [ ] Formato: `[✓] two-pointers/easy/01_pair_sum`
- [ ] Filtros: `--pattern`, `--difficulty`, `--incomplete`
- [ ] Colores: verde=completed, amarillo=in_progress, blanco=not_started

#### 2.2 Comando `start`
- [ ] Detectar editor del usuario (EDITOR env var)
- [ ] Soportar: nvim, vim, vscode, code
- [ ] `cz start 01_pair_sum` - buscar por número o nombre
- [ ] Abrir split: README.md (left) + problem.zig (right)
- [ ] Marcar como "in_progress" al abrir
- [ ] Manejar errores (problema no encontrado)

#### 2.3 Comando `test`
- [ ] Detectar problema del directorio actual
- [ ] Ejecutar `zig test problem_test.zig`
- [ ] Mostrar output formateado
- [ ] Si todos pasan, preguntar: "Mark as completed? [Y/n]"
- [ ] Actualizar progress.json

### Fase 3: Polish & Testing (Semana 3)

#### 3.1 Error Handling
- [ ] Mensajes de error claros y útiles
- [ ] Validación de inputs
- [ ] Manejo de filesystem errors
- [ ] Graceful degradation

#### 3.2 Documentation
- [ ] README.md para el CLI
- [ ] Help messages: `cz --help`, `cz <command> --help`
- [ ] Examples en documentación

#### 3.3 Installation
- [ ] Script de instalación: `./install.sh`
- [ ] Compilar y copiar a `~/.local/bin/cz`
- [ ] Verificar que funciona globalmente

#### 3.4 Testing
- [ ] Unit tests para cada módulo
- [ ] Integration tests para comandos
- [ ] Test en diferentes sistemas (si es posible)

---

## Decisiones Técnicas

### Argument Parsing
**Opción elegida:** Manual parsing (por ahora)
- Simple para MVP
- Zig stdlib tiene lo necesario
- Migrar a librería después si es necesario

### JSON Parsing
**Usar:** `std.json`
- Built-in, no dependencies
- Suficiente para nuestro caso de uso

### Editor Detection
**Strategy:**
1. Check env var `EDITOR`
2. Check env var `VISUAL`
3. Default: `nvim` (luego hacer detección inteligente)

**Split Commands:**
```bash
# Neovim
nvim -O README.md problem.zig

# VSCode
code --reuse-window -r README.md problem.zig

# Vim
vim -O README.md problem.zig
```

### File System Operations
**Usar:** `std.fs`
- Iterar directorios
- Leer archivos
- Crear directorios

### Home Directory
**Obtener:** `std.os.getenv("HOME")`
```zig
const home = std.os.getenv("HOME") orelse return error.HomeNotFound;
const config_dir = try std.fs.path.join(allocator, &[_][]const u8{
    home, ".cracking-zig"
});
```

---

## Command Line Interface

### Comandos del MVP

```bash
# Listar todos los problemas
cz list
cz list --pattern two-pointers
cz list --difficulty easy
cz list --incomplete

# Iniciar un problema
cz start 01_pair_sum          # Por número
cz start pair_sum             # Por nombre
cz start two-pointers/easy/01 # Por path parcial

# Ejecutar tests
cz test                        # En directorio del problema
cz test 01_pair_sum           # Especificar problema

# Help
cz --help
cz list --help
```

### Output Examples

```bash
$ cz list

Two Pointers (8/12 completed)
  Easy (6/8)
    [✓] 01_pair_sum_sorted
    [✓] 02_remove_duplicates
    [✓] 03_remove_element
    [✓] 04_merge_sorted_array
    [✓] 05_valid_palindrome
    [ ] 06_...

  Medium (2/4)
    [~] 01_longest_palindrome    (in progress)
    [✓] 02_container_with_most_water
    [ ] 03_three_sum
    [ ] 04_...

Sliding Window (3/8 completed)
  ...
```

```bash
$ cz start 01_pair_sum

Opening: two-pointers/easy/01_pair_sum_sorted
Editor: nvim

# Abre nvim con split
```

```bash
$ cz test

Running tests for: two-pointers/easy/01_pair_sum_sorted

✓ test "finds pair with positive numbers"
✓ test "handles empty array"
✓ test "no solution exists"
✓ test "handles duplicates"

All tests passed! (4/4)

Mark as completed? [Y/n]: y
✓ Problem marked as completed
```

---

## Mejoras Post-MVP

### Fase 4: Enhanced Features
- Interactive TUI mode con `libvaxis`
- Sistema de hints progresivos
- Comparación de soluciones
- Timing/stopwatch

### Fase 5: Advanced Features
- Spaced repetition algorithm
- Stats & analytics dashboard
- Export/import progress
- Notes system

---

## Testing Strategy

### Unit Tests
- `problem.zig`: scanning, parsing paths
- `progress.zig`: JSON read/write
- `fs.zig`: path manipulation

### Integration Tests
- End-to-end: `cz list` output correcto
- End-to-end: `cz start` abre editor
- Progress tracking: marcar como completado

### Manual Testing Checklist
- [ ] `cz list` muestra todos los problemas
- [ ] Filtros funcionan correctamente
- [ ] `cz start` abre editor con split
- [ ] `cz test` ejecuta y muestra resultados
- [ ] Progress se guarda correctamente
- [ ] Funciona desde cualquier directorio

---

## Consideraciones de UX

### Mensajes de Error
- Claros y accionables
- Sugerir comando correcto si hay typo
- Mostrar ayuda relevante

### Performance
- Scanning debe ser rápido (<100ms)
- Cache si es necesario (futuro)

### Compatibilidad
- Funcionar en Linux, macOS, Windows
- Manejar paths correctamente en cada OS

---

## Preguntas a Resolver

1. **Nombre del ejecutable:** `cz` ¿está bien?
2. **Default editor:** ¿Neovim, o detectar automáticamente?
3. **Dónde instalar:** `~/.local/bin/` o `/usr/local/bin/`?
4. **Pattern naming:** ¿Mantener kebab-case en IDs? (two-pointers vs two_pointers)

---

## Next Steps

1. Review este plan
2. Responder preguntas pendientes
3. Crear issues/tasks en GitHub (opcional)
4. Empezar Fase 1.1: Setup básico

---

**Última actualización:** 2025-01-16
**Autor:** José
**Status:** Planning