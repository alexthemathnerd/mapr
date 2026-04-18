from __future__ import annotations

import os
import sys
from pathlib import Path

if sys.platform == "win32":
    import PySide6
    os.add_dll_directory(str(Path(PySide6.__file__).parent))

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QQmlDebuggingEnabler


def main() -> None:
    QQmlDebuggingEnabler.enableDebugging(True)
    app = QGuiApplication(sys.argv)
    app.setApplicationName("Mapr")
    app.setOrganizationName("SiGMA")

    engine = QQmlApplicationEngine()
    engine.addImportPath(str(Path(__file__).parent / "view"))

    qml_path = Path(__file__).parent / "view" / "Mapr.qml"
    engine.load(str(qml_path))
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
