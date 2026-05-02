from __future__ import annotations

from PySide6.QtCore import QObject, Property, Signal, Slot
from PySide6.QtGui import QImage

_ZOOM_MIN = 0.1
_ZOOM_MAX = 8.0
_ZOOM_STEP = 1.25


class MapCanvasViewModel(QObject):
    zoomChanged = Signal()
    panChanged = Signal()
    imageChanged = Signal()

    def __init__(self, parent: QObject | None = None) -> None:
        super().__init__(parent)
        self._zoom: float = 1.0
        self._pan_x: float = 0.0
        self._pan_y: float = 0.0
        self._image: QImage = QImage()
        self._canvas_w: float = 0.0
        self._canvas_h: float = 0.0

    # ── Properties ─────────────────────────────────────────────────────────────

    @Property(float, notify=zoomChanged)
    def zoomLevel(self) -> float:
        return self._zoom

    @Property(int, notify=zoomChanged)
    def zoomPercent(self) -> int:
        return round(self._zoom * 100)

    @Property(float, notify=panChanged)
    def panX(self) -> float:
        return self._pan_x

    @Property(float, notify=panChanged)
    def panY(self) -> float:
        return self._pan_y

    # ── Internal helpers ───────────────────────────────────────────────────────

    def _clamp_zoom(self, zoom: float) -> float:
        return max(_ZOOM_MIN, min(_ZOOM_MAX, zoom))

    def _apply_zoom(self, zoom: float) -> None:
        clamped = self._clamp_zoom(zoom)
        if abs(clamped - self._zoom) > 1e-9:
            self._zoom = clamped
            self.zoomChanged.emit()

    # ── Slots ──────────────────────────────────────────────────────────────────

    @Slot()
    def zoomIn(self) -> None:
        self._apply_zoom(self._zoom * _ZOOM_STEP)

    @Slot()
    def zoomOut(self) -> None:
        self._apply_zoom(self._zoom / _ZOOM_STEP)

    @Slot()
    def zoomToFit(self) -> None:
        if self._canvas_w <= 0 or self._canvas_h <= 0:
            return
        if not self._image.isNull():
            iw, ih = self._image.width(), self._image.height()
            zoom = min(self._canvas_w / iw, self._canvas_h / ih)
        else:
            zoom = 1.0
        self._zoom = self._clamp_zoom(zoom)
        self._pan_x = 0.0
        self._pan_y = 0.0
        self.zoomChanged.emit()
        self.panChanged.emit()

    @Slot(float, float, float)
    def zoomAtPoint(self, factor: float, cx: float, cy: float) -> None:
        new_zoom = self._clamp_zoom(self._zoom * factor)
        if abs(new_zoom - self._zoom) < 1e-9:
            return
        ratio = new_zoom / self._zoom
        cw2 = self._canvas_w / 2.0
        ch2 = self._canvas_h / 2.0
        self._pan_x = self._pan_x * ratio + (cx - cw2) * (1.0 - ratio)
        self._pan_y = self._pan_y * ratio + (cy - ch2) * (1.0 - ratio)
        self._zoom = new_zoom
        self.zoomChanged.emit()
        self.panChanged.emit()

    @Slot(float, float)
    def setPan(self, x: float, y: float) -> None:
        self._pan_x = x
        self._pan_y = y
        self.panChanged.emit()

    @Slot(float, float)
    def setCanvasSize(self, w: float, h: float) -> None:
        self._canvas_w = w
        self._canvas_h = h

    def setMapImage(self, image: QImage) -> None:
        self._image = image
        self.imageChanged.emit()

    @Slot(str)
    def loadImageFromPath(self, path: str) -> None:
        image = QImage(path)
        if not image.isNull():
            self._image = image
            self.imageChanged.emit()

    @property
    def mapImage(self) -> QImage:
        return self._image
