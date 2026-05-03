from __future__ import annotations

from pathlib import Path

import numpy as np
from PySide6.QtCore import Property, QObject, Signal, Slot

from models.project import LayerState
from models.project_manager import ProjectManager

_LAYERS_DIR = "layers"


class ProjectViewModel(QObject):
    projectNameChanged = Signal(name="projectNameChanged")
    hasProjectChanged = Signal(name="hasProjectChanged")

    def __init__(self, parent: QObject | None = None) -> None:
        super().__init__(parent)
        self._state = None

    @Property(str, notify=projectNameChanged)
    def projectName(self) -> str:
        return self._state.name if self._state else ""

    @Property(bool, notify=hasProjectChanged)
    def hasProject(self) -> bool:
        return self._state is not None

    @Slot(str)
    def loadProject(self, path: str) -> None:
        """Open an existing project folder or create a new one from a heightmap file."""
        p = Path(path)
        if p.is_dir():
            self._state = ProjectManager.load(p)
        else:
            self._state = ProjectManager.create(p, p.parent)
        self.projectNameChanged.emit()
        self.hasProjectChanged.emit()

    @Slot()
    def save(self) -> None:
        if self._state:
            ProjectManager.save(self._state)

    @Slot("QVariantMap")
    def generate(self, params: dict) -> None:
        """Record a generation run with its hyperparameters and auto-save.

        Saves a NumPy zeros array as a placeholder until the generation
        backend produces real data.
        """
        if not self._state:
            return

        index = len(self._state.layers) + 1
        layer_name = f"Layer {index}"
        data_filename = f"layer_{index}.npy"
        data_rel = f"{_LAYERS_DIR}/{data_filename}"
        data_abs = self._state.folder / data_rel

        np.save(str(data_abs), np.zeros((0,), dtype=np.float32))

        self._state.layers.append(
            LayerState(
                name=layer_name,
                status="ready",
                data_path=data_rel,
                hyperparameters=dict(params),
            )
        )
        ProjectManager.save(self._state)
