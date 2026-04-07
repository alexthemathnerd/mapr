from __future__ import annotations

import sys
from pathlib import Path

from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine


def main() -> None:
    app = QGuiApplication(sys.argv)
    app.setApplicationName("Mapr")
    app.setOrganizationName("SiGMA")

    engine = QQmlApplicationEngine()
    engine.addImportPath(str(Path(__file__).parent))

    qml_path = Path(__file__).parent / "QML" / "Views" / "MainWindow.qml"
    engine.load(str(qml_path))

    if not engine.rootObjects():
        sys.exit(1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
