# Mapr

A fantasy world map generator built with PyQt6 and QML.

## Setup

```bash
pip install -r requirements.txt
```

## Running the Application

```bash
python -m frontend.main
```

## Development

## VSCode
If you are using an enviroment add this to your settings.json:
```json
{
    "terminal.integrated.env.windows": {
        "PATH": "${env:PATH};${workspaceFolder}\\.venv\\Lib\\site-packages\\PySide6\\Qt\\bin"
    }
}
```

### Lint

```bash
ruff check .
```

### Type Check

```bash
mypy .
```

### Tests

```bash
pytest tests/ -v
```
