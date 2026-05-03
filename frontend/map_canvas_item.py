from __future__ import annotations

from PySide6.QtCore import Property, Signal, QObject, QRect, QRectF
from PySide6.QtGui import QPainter, QColor
from PySide6.QtQml import QmlElement
from PySide6.QtQuick import QQuickPaintedItem

from viewmodels.map_canvas_view_model import MapCanvasViewModel

QML_IMPORT_NAME = "Components"
QML_IMPORT_MAJOR_VERSION = 1

_PLACEHOLDER_COLOR = QColor("#808080")


@QmlElement
class MapCanvasItem(QQuickPaintedItem):
    viewModelChanged = Signal()
    backgroundColorChanged = Signal()

    def __init__(self, parent=None) -> None:
        super().__init__(parent)
        self._view_model: MapCanvasViewModel | None = None
        self._bg_color: QColor = QColor("#F7F5F0")

    # ── Properties ─────────────────────────────────────────────────────────────

    def _get_view_model(self):
        return self._view_model

    def _set_view_model(self, vm) -> None:
        if self._view_model is vm:
            return
        if self._view_model is not None:
            self._view_model.zoomChanged.disconnect(self.update)
            self._view_model.panChanged.disconnect(self.update)
            self._view_model.imageChanged.disconnect(self.update)
        self._view_model = vm
        if vm is not None:
            vm.zoomChanged.connect(self.update)
            vm.panChanged.connect(self.update)
            vm.imageChanged.connect(self.update)
            vm.setCanvasSize(self.width(), self.height())
        self.viewModelChanged.emit()
        self.update()

    viewModel = Property(
        QObject,
        _get_view_model,
        _set_view_model,
        notify=viewModelChanged,
    )

    def _get_bg_color(self) -> QColor:
        return self._bg_color

    def _set_bg_color(self, color: QColor) -> None:
        self._bg_color = color
        self.backgroundColorChanged.emit()
        self.update()

    backgroundColor = Property(
        QColor,
        _get_bg_color,
        _set_bg_color,
        notify=backgroundColorChanged,
    )

    # ── QQuickItem overrides ────────────────────────────────────────────────────

    def geometryChange(self, new_geom: QRectF | QRect, old_geom: QRectF | QRect) -> None:
        super().geometryChange(new_geom, old_geom)
        if self._view_model is not None:
            self._view_model.setCanvasSize(new_geom.width(), new_geom.height())

    # ── Rendering ──────────────────────────────────────────────────────────────

    def paint(self, painter: QPainter) -> None:
        w = self.width()
        h = self.height()

        painter.fillRect(QRectF(0.0, 0.0, w, h), self._bg_color)

        vm = self._view_model
        zoom = vm.zoomLevel if vm is not None else 1.0
        pan_x = vm.panX if vm is not None else 0.0
        pan_y = vm.panY if vm is not None else 0.0
        image = vm.mapImage if vm is not None else None

        if image is not None and not image.isNull():
            # Real image: use actual pixel dimensions
            nat_w = float(image.width())
            nat_h = float(image.height())
        else:
            # Placeholder: 2:1 rectangle sized to fill canvas at zoom 1.0
            nat_h = min(w / 2.0, h)
            nat_w = nat_h * 2.0

        iw = nat_w * zoom
        ih = nat_h * zoom
        x = (w - iw) / 2.0 + pan_x
        y = (h - ih) / 2.0 + pan_y

        if image is not None and not image.isNull():
            painter.drawImage(QRectF(x, y, iw, ih), image)
        else:
            painter.fillRect(QRectF(x, y, iw, ih), _PLACEHOLDER_COLOR)
