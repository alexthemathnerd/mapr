from __future__ import annotations

import json
import time
from datetime import datetime
from pathlib import Path

from PySide6.QtCore import Property, QObject, QStandardPaths, QUrl, Signal, Slot

_ICON_PALETTE = [
    {"iconBg": "#EEEDFE", "iconStroke": "#3C3489"},
    {"iconBg": "#E1F5EE", "iconStroke": "#0F6E56"},
    {"iconBg": "#FAECE7", "iconStroke": "#993C1D"},
    {"iconBg": "#FAEEDA", "iconStroke": "#854F0B"},
    {"iconBg": "#FBEAF0", "iconStroke": "#993556"},
]

_MAX_RECENT = 10


def _relative_time(ts: float) -> str:
    delta = time.time() - ts
    if delta < 60:
        return "Just now"
    if delta < 3600:
        return f"{int(delta / 60)}m ago"
    if delta < 86400:
        return f"{int(delta / 3600)}h ago"
    if delta < 172800:
        return "Yesterday"
    if delta < 604800:
        return f"{int(delta / 86400)} days ago"
    if delta < 1_209_600:
        return "Last week"
    return datetime.fromtimestamp(ts).strftime("%b %d")


def _icon_for(path: str) -> dict:
    return _ICON_PALETTE[abs(hash(path)) % len(_ICON_PALETTE)]


def _storage_path() -> Path:
    base = QStandardPaths.writableLocation(
        QStandardPaths.StandardLocation.AppDataLocation
    )
    return Path(base) / "recent_projects.json"


class StartupViewModel(QObject):
    recentProjectsChanged = Signal(name="recentProjectsChanged")
    projectSelected = Signal(str, name="projectSelected")

    def __init__(self, parent: QObject | None = None) -> None:
        super().__init__(parent)
        self._raw: list[dict] = []
        self._load()

    @Property(list, notify=recentProjectsChanged)
    def recentProjects(self) -> list[dict]:
        return [
            {
                "name": entry["name"],
                "path": entry["path"],
                "time": _relative_time(entry["opened_at"]),
                **_icon_for(entry["path"]),
            }
            for entry in self._raw
        ]

    @Slot(str)
    def newProject(self, url: str) -> None:
        path = QUrl(url).toLocalFile()
        name = Path(path).stem
        self._add_recent(name, path)
        self.projectSelected.emit(path)

    @Slot(str)
    def openProject(self, url: str) -> None:
        path = QUrl(url).toLocalFile()
        name = Path(path).stem
        self._add_recent(name, path)
        self.projectSelected.emit(path)

    @Slot(str)
    def openRecent(self, path: str) -> None:
        self._add_recent(Path(path).stem, path)
        self.projectSelected.emit(path)

    # ── Internal ──────────────────────────────────────────────────

    def _add_recent(self, name: str, path: str) -> None:
        self._raw = [e for e in self._raw if e["path"] != path]
        self._raw.insert(0, {"name": name, "path": path, "opened_at": time.time()})
        self._raw = self._raw[:_MAX_RECENT]
        self._save()
        self.recentProjectsChanged.emit()

    def _load(self) -> None:
        p = _storage_path()
        if p.exists():
            try:
                self._raw = json.loads(p.read_text(encoding="utf-8"))
            except (json.JSONDecodeError, OSError):
                self._raw = []

    def _save(self) -> None:
        p = _storage_path()
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(json.dumps(self._raw, indent=2), encoding="utf-8")
