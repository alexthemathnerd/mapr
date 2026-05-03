from __future__ import annotations

import json
import shutil
from pathlib import Path

from frontend.models.project import LayerState, ProjectState

_CONFIG_FILE = "config.json"
_LAYERS_DIR = "layers"
_HEIGHTMAP_FILENAME = "heightmap.png"
_VERSION = 1


class ProjectManager:
    @staticmethod
    def create(heightmap: Path, parent_dir: Path) -> ProjectState:
        """Create a new project folder from a heightmap image."""
        name = heightmap.stem
        folder = parent_dir / name
        folder.mkdir(parents=True, exist_ok=True)
        layers_dir = folder / _LAYERS_DIR
        layers_dir.mkdir(exist_ok=True)

        dest = layers_dir / _HEIGHTMAP_FILENAME
        shutil.copy2(heightmap, dest)

        state = ProjectState(
            name=name,
            folder=folder,
            heightmap_path=f"{_LAYERS_DIR}/{_HEIGHTMAP_FILENAME}",
        )
        ProjectManager._write_config(state)
        return state

    @staticmethod
    def save(state: ProjectState) -> None:
        """Persist current project state to disk."""
        ProjectManager._write_config(state)

    @staticmethod
    def load(folder: Path) -> ProjectState:
        """Load a project from a folder, raising on missing or corrupt config."""
        config_path = folder / _CONFIG_FILE
        if not config_path.exists():
            raise FileNotFoundError(f"No config file found in {folder}")

        try:
            data = json.loads(config_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            raise ValueError(f"Corrupt config file in {folder}") from exc

        try:
            layers = [
                LayerState(
                    name=layer["name"],
                    status=layer["status"],
                    image_path=layer["image"],
                    hyperparameters=layer.get("params", {}),
                )
                for layer in data.get("layers", [])
            ]
            return ProjectState(
                name=data["name"],
                folder=folder,
                heightmap_path=data["heightmap"],
                layers=layers,
                version=data.get("version", _VERSION),
            )
        except KeyError as exc:
            raise ValueError(f"Invalid config structure in {folder}: missing key {exc}") from exc

    @staticmethod
    def _write_config(state: ProjectState) -> None:
        config = {
            "version": state.version,
            "name": state.name,
            "heightmap": state.heightmap_path,
            "layers": [
                {
                    "name": layer.name,
                    "status": layer.status,
                    "image": layer.image_path,
                    "params": layer.hyperparameters,
                }
                for layer in state.layers
            ],
        }
        config_path = state.folder / _CONFIG_FILE
        config_path.write_text(json.dumps(config, indent=2), encoding="utf-8")
