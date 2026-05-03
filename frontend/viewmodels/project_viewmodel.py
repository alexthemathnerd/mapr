from __future__ import annotations

import shutil
from pathlib import Path

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

    @Slot(str, "QVariantMap")
    def generate(self, algorithm: str, params: dict) -> None:
        """Record a generation run with its hyperparameters and auto-save.

        Until the generation backend exists, the heightmap is copied as a
        placeholder so the project folder stays self-contained.
        """
        if not self._state:
            return

        hyperparams = {"algorithm": algorithm, **params}
        layer_name = algorithm.replace("_", " ").title()

        existing = sum(1 for la in self._state.layers if la.name.startswith(layer_name))
        suffix = f" {existing + 1}" if existing else ""

        src = self._state.folder / self._state.heightmap_path
        img_filename = f"{algorithm}{suffix.replace(' ', '_')}.png"
        img_rel = f"{_LAYERS_DIR}/{img_filename}"
        img_abs = self._state.folder / img_rel
        shutil.copy2(src, img_abs)

        self._state.layers.append(
            LayerState(
                name=f"{layer_name}{suffix}",
                status="ready",
                image_path=img_rel,
                hyperparameters=hyperparams,
            )
        )
        ProjectManager.save(self._state)
