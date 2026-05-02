from __future__ import annotations

import os
import sys
from pathlib import Path

if sys.platform == "win32":
    import PySide6
    os.add_dll_directory(str(Path(PySide6.__file__).parent))

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QQmlDebuggingEnabler

from viewmodels.startup_viewmodel import StartupViewModel


def main() -> None:
    QQmlDebuggingEnabler.enableDebugging(True)
    app = QGuiApplication(sys.argv)
    app.setApplicationName("Mapr")
    app.setOrganizationName("SiGMA")

    startup_vm = StartupViewModel()

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("startupVM", startup_vm)
    engine.addImportPath(str(Path(__file__).parent / "view"))

    qml_path = Path(__file__).parent / "view" / "Mapr.qml"
    engine.load(str(qml_path))

    app.lastWindowClosed.connect(app.quit)
    exit_code = app.exec()
    del engine
    sys.exit(exit_code)


if __name__ == "__main__":
    main()
