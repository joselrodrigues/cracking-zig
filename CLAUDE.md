# Project Guidelines

## Zig Documentation
- Siempre que quieras darme información de Zig, investiga en Context7 cuál es el approach actual
- Usa funciones de la biblioteca estándar cuando estén disponibles (ej: `std.ascii.isAlphanumeric()`, `std.mem.eql()`)

## Code Style

### Examples
- Todos los ejemplos de código DEBEN ser en Zig
- Nunca uses Python, JavaScript, u otros lenguajes para ejemplos

### Comments and Emojis
- No uses comentarios innecesarios en el código
- No uses emojis en el código (solo en mensajes de chat si es necesario)

### Tests
- Los nombres de tests DEBEN usar lenguaje natural con espacios
- ✅ Correcto: `test "finds pair with positive numbers"`
- ❌ Incorrecto: `test "finds_pair_with_positive_numbers"`

## Git Commits
- NUNCA incluyas atribución de Claude en los commits
- No uses frases como "Generated with Claude" o "Co-Authored-By: Claude"
- Los mensajes deben ser concisos y describir los cambios técnicos

## Project Structure

### Algorithm Problems
- Organiza por patrón (two-pointers, sliding-window, etc.)
- Cada patrón tiene subdirectorios por dificultad (easy, medium, hard)
- Cada problema debe tener:
  - `README.md` - Descripción del problema
  - `XX_problem_name.zig` - Archivo principal (stub para implementar)
  - `XX_problem_name_solution.zig` - Solución de referencia
  - `XX_problem_name_test.zig` - Tests comprehensivos

### File Naming
- Usa números para ordenar: `01_`, `02_`, etc.
- Usa snake_case para nombres de archivos
- Los tests deben importar del archivo principal, no del solution

## Code Practices
- Evita over-engineering
- Solo agrega lo que es necesario para el problema
- Prefiere claridad sobre micro-optimizaciones
- Maneja casos edge correctamente (empty arrays, single elements, etc.)
