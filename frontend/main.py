from __future__ import annotations

import os
import sys
from pathlib import Path

if sys.platform == "win32":
    import PySide6
    os.add_dll_directory(str(Path(PySide6.__file__).parent))

from PySide6.QtGui import QGuiApplication, QImage, QPainter, QRadialGradient, QColor
from PySide6.QtQml import QQmlApplicationEngine, QQmlDebuggingEnabler

import map_canvas_item  # noqa: F401  # registers MapCanvasItem via @QmlElement
import viewmodels.map_canvas_view_model  # noqa: F401  # registers MapCanvasViewModel via @QmlElement
from viewmodels.startup_viewmodel import StartupViewModel

_ASSETS_DIR = Path(__file__).parent.parent / "assets"
_TEST_HEIGHTMAP = _ASSETS_DIR / "test_heightmap.png"


def _generate_test_heightmap() -> None:
    """Creates a synthetic 1600×800 heightmap PNG for development testing."""
    _ASSETS_DIR.mkdir(exist_ok=True)
    W, H = 1600, 800
    img = QImage(W, H, QImage.Format.Format_ARGB32_Premultiplied)
    img.fill(QColor(30, 50, 80))

    p = QPainter(img)

    def radial(cx: float, cy: float, r: float, stops: list[tuple[float, QColor]]) -> None:
        g = QRadialGradient(cx, cy, r)
        for pos, col in stops:
            g.setColorAt(pos, col)
        p.fillRect(0, 0, W, H, g)

    radial(800, 400, 400, [
        (0.00, QColor(230, 215, 185)),
        (0.30, QColor(145, 175, 100)),
        (0.58, QColor(70, 110, 80)),
        (0.78, QColor(45, 75, 105, 140)),
        (1.00, QColor(30, 50, 80, 0)),
    ])
    radial(330, 190, 190, [
        (0.00, QColor(210, 200, 175)),
        (0.50, QColor(120, 155, 100)),
        (1.00, QColor(30, 50, 80, 0)),
    ])
    radial(1240, 580, 155, [
        (0.00, QColor(195, 175, 145)),
        (0.55, QColor(100, 135, 85)),
        (1.00, QColor(30, 50, 80, 0)),
    ])
    radial(1050, 165, 100, [
        (0.00, QColor(185, 170, 140)),
        (0.60, QColor(95, 125, 80)),
        (1.00, QColor(30, 50, 80, 0)),
    ])

    p.end()
    img.save(str(_TEST_HEIGHTMAP))


def main() -> None:
    QQmlDebuggingEnabler.enableDebugging(True)
    app = QGuiApplication(sys.argv)
    app.setApplicationName("Mapr")
    app.setOrganizationName("SiGMA")

    if not _TEST_HEIGHTMAP.exists():
        _generate_test_heightmap()
    startup_vm = StartupViewModel()

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("startupVM", startup_vm)
    engine.addImportPath(str(Path(__file__).parent / "view"))
    engine.rootContext().setContextProperty(
        "devTestImagePath",
        str(_TEST_HEIGHTMAP) if _TEST_HEIGHTMAP.exists() else "",
    )

    qml_path = Path(__file__).parent / "view" / "Mapr.qml"
    engine.load(str(qml_path))

    app.lastWindowClosed.connect(app.quit)
    exit_code = app.exec()
    del engine
    sys.exit(exit_code)


if __name__ == "__main__":
    main()
