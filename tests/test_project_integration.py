from __future__ import annotations

import io
import json
import struct
import zlib
from pathlib import Path

import numpy as np
import pytest

from frontend.models.project import LayerState
from frontend.models.project_manager import ProjectManager


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _make_png(width: int = 4, height: int = 4) -> bytes:
    """Return a minimal valid RGB PNG with all-white pixels."""
    sig = b"\x89PNG\r\n\x1a\n"

    ihdr_data = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    ihdr_crc = zlib.crc32(b"IHDR" + ihdr_data) & 0xFFFFFFFF
    ihdr = struct.pack(">I", 13) + b"IHDR" + ihdr_data + struct.pack(">I", ihdr_crc)

    raw = (b"\x00" + b"\xff\xff\xff" * width) * height
    compressed = zlib.compress(raw)
    idat_crc = zlib.crc32(b"IDAT" + compressed) & 0xFFFFFFFF
    idat = (
        struct.pack(">I", len(compressed))
        + b"IDAT"
        + compressed
        + struct.pack(">I", idat_crc)
    )

    iend_crc = zlib.crc32(b"IEND") & 0xFFFFFFFF
    iend = struct.pack(">I", 0) + b"IEND" + struct.pack(">I", iend_crc)

    return sig + ihdr + idat + iend


def _make_npy() -> bytes:
    """Return bytes of a minimal valid .npy file (empty float32 array)."""
    buf = io.BytesIO()
    np.save(buf, np.zeros((0,), dtype=np.float32))
    return buf.getvalue()


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------


@pytest.fixture()
def heightmap(tmp_path: Path) -> Path:
    png = tmp_path / "test_heightmap.png"
    png.write_bytes(_make_png())
    return png


@pytest.fixture()
def workspace(tmp_path: Path) -> Path:
    d = tmp_path / "workspace"
    d.mkdir()
    return d


# ---------------------------------------------------------------------------
# AC1: Create — folder and project file exist on disk
# ---------------------------------------------------------------------------


class TestProjectCreate:
    def test_creates_project_folder(self, heightmap: Path, workspace: Path) -> None:
        state = ProjectManager.create(heightmap, workspace)
        assert state.folder.is_dir()

    def test_creates_project_file(self, heightmap: Path, workspace: Path) -> None:
        state = ProjectManager.create(heightmap, workspace)
        assert (state.folder / "project.json").is_file()

    def test_project_name_matches_heightmap_stem(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        data = json.loads((state.folder / "project.json").read_text())
        assert data["name"] == "test_heightmap"

    def test_project_has_heightmap_key(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        data = json.loads((state.folder / "project.json").read_text())
        assert "heightmap" in data

    def test_project_has_empty_layers_list(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        data = json.loads((state.folder / "project.json").read_text())
        assert data["layers"] == []

    def test_project_version_is_set(self, heightmap: Path, workspace: Path) -> None:
        state = ProjectManager.create(heightmap, workspace)
        data = json.loads((state.folder / "project.json").read_text())
        assert data["version"] == 1

    def test_copies_heightmap_bytes_into_project(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        copied = state.folder / state.heightmap_path
        assert copied.is_file()
        assert copied.read_bytes() == heightmap.read_bytes()

    def test_project_name_derived_from_stem(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        assert state.name == "test_heightmap"


# ---------------------------------------------------------------------------
# AC2: Save — layer metadata and data file written to disk
# ---------------------------------------------------------------------------


class TestProjectSave:
    def _create_with_layer(
        self, heightmap: Path, workspace: Path, layer_name: str = "Rivers"
    ) -> tuple:
        state = ProjectManager.create(heightmap, workspace)
        data_rel = f"layers/{layer_name.lower()}.npy"
        data_abs = state.folder / data_rel
        data_abs.write_bytes(_make_npy())
        state.layers.append(
            LayerState(name=layer_name, status="ready", data_path=data_rel)
        )
        ProjectManager.save(state)
        return state, data_abs

    def test_layer_data_file_exists_after_save(
        self, heightmap: Path, workspace: Path
    ) -> None:
        _, data_abs = self._create_with_layer(heightmap, workspace)
        assert data_abs.is_file()

    def test_project_records_layer_name(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state, _ = self._create_with_layer(heightmap, workspace)
        data = json.loads((state.folder / "project.json").read_text())
        assert data["layers"][0]["name"] == "Rivers"

    def test_project_records_layer_status(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state, _ = self._create_with_layer(heightmap, workspace)
        data = json.loads((state.folder / "project.json").read_text())
        assert data["layers"][0]["status"] == "ready"

    def test_project_records_layer_data_path(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state, _ = self._create_with_layer(heightmap, workspace)
        data = json.loads((state.folder / "project.json").read_text())
        assert data["layers"][0]["data"] == "layers/rivers.npy"

    def test_save_overwrites_previous_layer_list(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)

        npy1 = state.folder / "layers" / "rivers.npy"
        npy1.write_bytes(_make_npy())
        state.layers.append(LayerState("Rivers", "ready", "layers/rivers.npy"))
        ProjectManager.save(state)

        npy2 = state.folder / "layers" / "biomes.npy"
        npy2.write_bytes(_make_npy())
        state.layers = [LayerState("Biomes", "ready", "layers/biomes.npy")]
        ProjectManager.save(state)

        data = json.loads((state.folder / "project.json").read_text())
        assert len(data["layers"]) == 1
        assert data["layers"][0]["name"] == "Biomes"

    def test_multiple_layers_all_recorded(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        for name in ["Rivers", "Biomes", "Roads"]:
            npy = state.folder / "layers" / f"{name.lower()}.npy"
            npy.write_bytes(_make_npy())
            state.layers.append(
                LayerState(name=name, status="ready", data_path=f"layers/{name.lower()}.npy")
            )
        ProjectManager.save(state)

        data = json.loads((state.folder / "project.json").read_text())
        assert len(data["layers"]) == 3

    def test_project_records_hyperparameters(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        params = {"seed": 42, "scale": 5.0}
        npy = state.folder / "layers" / "rivers.npy"
        npy.write_bytes(_make_npy())
        state.layers.append(
            LayerState(
                name="Rivers",
                status="ready",
                data_path="layers/rivers.npy",
                hyperparameters=params,
            )
        )
        ProjectManager.save(state)

        data = json.loads((state.folder / "project.json").read_text())
        assert data["layers"][0]["params"] == params

    def test_empty_hyperparameters_written_as_empty_dict(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        npy = state.folder / "layers" / "rivers.npy"
        npy.write_bytes(_make_npy())
        state.layers.append(
            LayerState(name="Rivers", status="ready", data_path="layers/rivers.npy")
        )
        ProjectManager.save(state)

        data = json.loads((state.folder / "project.json").read_text())
        assert data["layers"][0]["params"] == {}


# ---------------------------------------------------------------------------
# AC3: Load — full state restored after round-trip
# ---------------------------------------------------------------------------


class TestProjectLoad:
    def _round_trip(
        self, heightmap: Path, workspace: Path, layer_names: list[str] | None = None
    ):
        state = ProjectManager.create(heightmap, workspace)
        for name in layer_names or []:
            npy = state.folder / "layers" / f"{name.lower()}.npy"
            npy.write_bytes(_make_npy())
            state.layers.append(
                LayerState(name=name, status="ready", data_path=f"layers/{name.lower()}.npy")
            )
        ProjectManager.save(state)
        return state, ProjectManager.load(state.folder)

    def test_restores_project_name(self, heightmap: Path, workspace: Path) -> None:
        state, loaded = self._round_trip(heightmap, workspace)
        assert loaded.name == state.name

    def test_restores_heightmap_path(self, heightmap: Path, workspace: Path) -> None:
        state, loaded = self._round_trip(heightmap, workspace)
        assert loaded.heightmap_path == state.heightmap_path

    def test_restores_folder_path(self, heightmap: Path, workspace: Path) -> None:
        state, loaded = self._round_trip(heightmap, workspace)
        assert loaded.folder == state.folder

    def test_restores_layer_count(self, heightmap: Path, workspace: Path) -> None:
        _, loaded = self._round_trip(heightmap, workspace, ["Rivers", "Biomes"])
        assert len(loaded.layers) == 2

    def test_restores_layer_names_in_order(
        self, heightmap: Path, workspace: Path
    ) -> None:
        _, loaded = self._round_trip(heightmap, workspace, ["Rivers", "Biomes"])
        assert [layer.name for layer in loaded.layers] == ["Rivers", "Biomes"]

    def test_restores_layer_status(self, heightmap: Path, workspace: Path) -> None:
        _, loaded = self._round_trip(heightmap, workspace, ["Rivers"])
        assert loaded.layers[0].status == "ready"

    def test_restores_layer_data_paths(
        self, heightmap: Path, workspace: Path
    ) -> None:
        _, loaded = self._round_trip(heightmap, workspace, ["Rivers"])
        assert loaded.layers[0].data_path == "layers/rivers.npy"

    def test_layer_data_exists_on_disk_after_reload(
        self, heightmap: Path, workspace: Path
    ) -> None:
        _, loaded = self._round_trip(heightmap, workspace, ["Rivers", "Biomes"])
        for layer in loaded.layers:
            assert (loaded.folder / layer.data_path).is_file()

    def test_heightmap_copy_exists_on_disk_after_reload(
        self, heightmap: Path, workspace: Path
    ) -> None:
        _, loaded = self._round_trip(heightmap, workspace)
        assert (loaded.folder / loaded.heightmap_path).is_file()

    def test_restores_layer_hyperparameters(
        self, heightmap: Path, workspace: Path
    ) -> None:
        params = {"seed": 7, "scale": 3.0, "islands": True}
        state = ProjectManager.create(heightmap, workspace)
        npy = state.folder / "layers" / "rivers.npy"
        npy.write_bytes(_make_npy())
        state.layers.append(
            LayerState(
                name="Rivers",
                status="ready",
                data_path="layers/rivers.npy",
                hyperparameters=params,
            )
        )
        ProjectManager.save(state)
        loaded = ProjectManager.load(state.folder)
        assert loaded.layers[0].hyperparameters == params

    def test_missing_params_key_defaults_to_empty_dict(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        project_path = state.folder / "project.json"
        data = json.loads(project_path.read_text())
        data["layers"] = [{"name": "Rivers", "status": "ready", "data": "layers/rivers.npy"}]
        project_path.write_text(json.dumps(data), encoding="utf-8")
        loaded = ProjectManager.load(state.folder)
        assert loaded.layers[0].hyperparameters == {}


# ---------------------------------------------------------------------------
# AC4: Error handling — missing or corrupt project folder
# ---------------------------------------------------------------------------


class TestProjectErrorHandling:
    def test_load_nonexistent_folder_raises_file_not_found(
        self, workspace: Path
    ) -> None:
        with pytest.raises(FileNotFoundError):
            ProjectManager.load(workspace / "nonexistent")

    def test_load_folder_without_project_file_raises_file_not_found(
        self, workspace: Path
    ) -> None:
        empty = workspace / "no_project"
        empty.mkdir()
        with pytest.raises(FileNotFoundError):
            ProjectManager.load(empty)

    def test_load_corrupt_json_raises_value_error(self, workspace: Path) -> None:
        folder = workspace / "corrupt"
        folder.mkdir()
        (folder / "project.json").write_text("{not valid json", encoding="utf-8")
        with pytest.raises(ValueError, match="Corrupt project file"):
            ProjectManager.load(folder)

    def test_load_missing_required_key_raises_value_error(
        self, workspace: Path
    ) -> None:
        folder = workspace / "incomplete"
        folder.mkdir()
        (folder / "project.json").write_text(
            json.dumps({"version": 1}), encoding="utf-8"
        )
        with pytest.raises(ValueError, match="Invalid project file"):
            ProjectManager.load(folder)

    def test_create_is_idempotent_for_existing_folder(
        self, heightmap: Path, workspace: Path
    ) -> None:
        ProjectManager.create(heightmap, workspace)
        state2 = ProjectManager.create(heightmap, workspace)
        assert state2.folder.is_dir()
