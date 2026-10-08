# moviemakerchatbot

Movie Maker Chatbot is a Prolog-based cinematic scene generator with:
- a web UI
- JSON API endpoints
- rendering modes (pixel, vector, rendered)
- scene regeneration support

## Complete Command Showcase

> All commands below are meant to be run from the repository root.

---

### 1) Install prerequisites

```bash
# Ubuntu / Debian
sudo apt update
sudo apt install -y swi-prolog curl
```

**What this does:**
- installs `swipl` (needed to run the app and tests)
- installs `curl` (used for API examples)

---

### 2) Run the web app

```bash
swipl -q -s src/movie_maker_app.pl -g main
```

**What this does:**
- loads the application entry point (`src/movie_maker_app.pl`)
- starts the HTTP server on port `8080`
- prints: `Movie Maker server running on http://localhost:8080`

Open this in a browser:

```text
http://localhost:8080
```

---

### 3) Generate a movie via API (`/api/generate`)

```bash
curl -s -X POST http://localhost:8080/api/generate \
  -H 'Content-Type: application/json' \
  -d '{
    "sentence": "A sailing ship crosses a golden ocean at sunset.",
    "style": "vector",
    "duration": 20
  }'
```

**What this does:**
- sends a prompt sentence + rendering style + duration
- returns JSON with:
  - `message` (chatbot summary)
  - `movie` (serialized movie term)
  - `html` (rendered preview)

---

### 4) Regenerate a scene via API (`/api/regenerate`)

```bash
curl -s -X POST http://localhost:8080/api/regenerate \
  -H 'Content-Type: application/json' \
  -d '{
    "sentence": "A sailing ship crosses a golden ocean at sunset.",
    "style": "vector",
    "duration": 20,
    "instruction": "Make the ending peaceful.",
    "target": "scene(4)"
  }'
```

**What this does:**
- rebuilds the movie from your sentence/options
- applies your edit instruction to the requested scene
- returns the updated `movie` JSON and rendered `html` preview

The `target` accepts an existing scene index such as `"scene(2)"` or `2`. If omitted, it defaults to `"scene(4)"`. The web UI also lets you select a scene.

---

### 5) Use core predicates directly (CLI one-liners)

Generate movie structure:

```bash
swipl -q -s src/movie_maker.pl -g "movie('A rocket launches.', [style(pixel),duration(20)], Movie), writeln(Movie), halt."
```

Generate pixel HTML:

```bash
swipl -q -s src/movie_maker.pl -g "movie_html('A ship crosses the ocean.', HTML), writeln(HTML), halt."
```

Generate vector HTML:

```bash
swipl -q -s src/movie_maker.pl -g "movie_vector('Two astronauts dance on the moon.', HTML), writeln(HTML), halt."
```

Generate rendered HTML:

```bash
swipl -q -s src/movie_maker.pl -g "movie_rendered('A giant wave approaches a coastal city.', HTML), writeln(HTML), halt."
```

Generate movie + song:

```bash
swipl -q -s src/movie_maker.pl -g "movie_and_song('A lonely traveller finally comes home.', Movie, Song), writeln(Movie), writeln(Song), halt."
```

Regenerate a scene in-memory:

```bash
swipl -q -s src/movie_maker.pl -g "movie('A tiger escapes from a palace during a thunderstorm.', [], M0), regenerate(scene(4), 'Make this more spectacular', M0, M1), writeln(M1), halt."
```

**What this does:**
- runs the core movie maker pipeline without starting the web server
- useful for debugging and automation scripts

---

### 6) Run the test suite

```bash
swipl -q -f tests.pl
```

**What this does:**
- executes all unit + integration tests from `tests/tests.pl`
- validates parsing, scene generation, renderers, song mapping, regeneration, and IO pairs

---

### 7) Useful development checks

List exported public predicates:

```bash
swipl -q -s src/movie_maker.pl -g "listing(movie_maker:movie/3), listing(movie_maker:movie_html/2), listing(movie_maker:movie_vector/2), listing(movie_maker:movie_rendered/2), listing(movie_maker:movie_and_song/3), listing(movie_maker:regenerate/4), halt."
```

Inspect server route handlers:

```bash
swipl -q -s src/server.pl -g "listing(server:api_generate/1), listing(server:api_regenerate/1), halt."
```

**What this does:**
- prints predicate definitions directly from loaded modules
- helps confirm runtime behavior quickly
