from __future__ import annotations

import json
import shutil
from pathlib import Path

from models.project import LayerState, ProjectState

_PROJECT_FILE = "project.json"
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
        ProjectManager._write_project(state)
        return state

    @staticmethod
    def save(state: ProjectState) -> None:
        """Persist current project state to disk."""
        ProjectManager._write_project(state)

    @staticmethod
    def load(folder: Path) -> ProjectState:
        """Load a project from a folder, raising on missing or corrupt project file."""
        project_path = folder / _PROJECT_FILE
        if not project_path.exists():
            raise FileNotFoundError(f"No project file found in {folder}")

        try:
            data = json.loads(project_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            raise ValueError(f"Corrupt project file in {folder}") from exc

        try:
            layers = [
                LayerState(
                    name=layer["name"],
                    status=layer["status"],
                    data_path=layer["data"],
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
            raise ValueError(f"Invalid project file in {folder}: missing key {exc}") from exc

    @staticmethod
    def _write_project(state: ProjectState) -> None:
        project = {
            "version": state.version,
            "name": state.name,
            "heightmap": state.heightmap_path,
            "layers": [
                {
                    "name": layer.name,
                    "status": layer.status,
                    "data": layer.data_path,
                    "params": layer.hyperparameters,
                }
                for layer in state.layers
            ],
        }
        project_path = state.folder / _PROJECT_FILE
        project_path.write_text(json.dumps(project, indent=2), encoding="utf-8")
