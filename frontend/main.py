from __future__ import annotations

import sys
from pathlib import Path

from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine


def main() -> None:
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()

    qml_path = Path(__file__).parent / "views" / "MainWindow.qml"
    engine.load(str(qml_path))

    if not engine.rootObjects():
        sys.exit(1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
