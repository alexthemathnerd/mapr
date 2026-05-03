from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class LayerState:
    name: str
    status: str  # "ready" | "empty" | "locked"
    data_path: str  # relative to project folder, .npy file
    hyperparameters: dict = field(default_factory=dict)


@dataclass
class ProjectState:
    name: str
    folder: Path
    heightmap_path: str  # relative to project folder
    layers: list[LayerState] = field(default_factory=list)
    version: int = 1
