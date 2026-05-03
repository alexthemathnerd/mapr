from __future__ import annotations

import json
import struct
import zlib
from pathlib import Path

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

    # One filter byte (0 = None) followed by RGB pixels per scanline
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
# AC1: Create — folder and config exist on disk
# ---------------------------------------------------------------------------


class TestProjectCreate:
    def test_creates_project_folder(self, heightmap: Path, workspace: Path) -> None:
        state = ProjectManager.create(heightmap, workspace)
        assert state.folder.is_dir()

    def test_creates_config_file(self, heightmap: Path, workspace: Path) -> None:
        state = ProjectManager.create(heightmap, workspace)
        assert (state.folder / "config.json").is_file()

    def test_config_name_matches_heightmap_stem(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        config = json.loads((state.folder / "config.json").read_text())
        assert config["name"] == "test_heightmap"

    def test_config_has_heightmap_key(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        config = json.loads((state.folder / "config.json").read_text())
        assert "heightmap" in config

    def test_config_has_empty_layers_list(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        config = json.loads((state.folder / "config.json").read_text())
        assert config["layers"] == []

    def test_config_version_is_set(self, heightmap: Path, workspace: Path) -> None:
        state = ProjectManager.create(heightmap, workspace)
        config = json.loads((state.folder / "config.json").read_text())
        assert config["version"] == 1

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
# AC2: Save — layer metadata and image written to disk
# ---------------------------------------------------------------------------


class TestProjectSave:
    def _create_with_layer(
        self, heightmap: Path, workspace: Path, layer_name: str = "Rivers"
    ) -> tuple:
        state = ProjectManager.create(heightmap, workspace)
        img_rel = f"layers/{layer_name.lower()}.png"
        img_abs = state.folder / img_rel
        img_abs.write_bytes(_make_png())
        state.layers.append(
            LayerState(name=layer_name, status="ready", image_path=img_rel)
        )
        ProjectManager.save(state)
        return state, img_abs

    def test_layer_image_exists_after_save(
        self, heightmap: Path, workspace: Path
    ) -> None:
        _, img_abs = self._create_with_layer(heightmap, workspace)
        assert img_abs.is_file()

    def test_config_records_layer_name(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state, _ = self._create_with_layer(heightmap, workspace)
        config = json.loads((state.folder / "config.json").read_text())
        assert config["layers"][0]["name"] == "Rivers"

    def test_config_records_layer_status(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state, _ = self._create_with_layer(heightmap, workspace)
        config = json.loads((state.folder / "config.json").read_text())
        assert config["layers"][0]["status"] == "ready"

    def test_config_records_layer_image_path(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state, _ = self._create_with_layer(heightmap, workspace)
        config = json.loads((state.folder / "config.json").read_text())
        assert config["layers"][0]["image"] == "layers/rivers.png"

    def test_save_overwrites_previous_layer_list(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)

        img1 = state.folder / "layers" / "rivers.png"
        img1.write_bytes(_make_png())
        state.layers.append(LayerState("Rivers", "ready", "layers/rivers.png"))
        ProjectManager.save(state)

        img2 = state.folder / "layers" / "biomes.png"
        img2.write_bytes(_make_png())
        state.layers = [LayerState("Biomes", "ready", "layers/biomes.png")]
        ProjectManager.save(state)

        config = json.loads((state.folder / "config.json").read_text())
        assert len(config["layers"]) == 1
        assert config["layers"][0]["name"] == "Biomes"

    def test_multiple_layers_all_recorded(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        for name in ["Rivers", "Biomes", "Roads"]:
            img = state.folder / "layers" / f"{name.lower()}.png"
            img.write_bytes(_make_png())
            state.layers.append(
                LayerState(name=name, status="ready", image_path=f"layers/{name.lower()}.png")
            )
        ProjectManager.save(state)

        config = json.loads((state.folder / "config.json").read_text())
        assert len(config["layers"]) == 3

    def test_config_records_hyperparameters(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        params = {"algorithm": "perlin_noise", "seed": 42, "scale": 5.0}
        img = state.folder / "layers" / "rivers.png"
        img.write_bytes(_make_png())
        state.layers.append(
            LayerState(
                name="Rivers",
                status="ready",
                image_path="layers/rivers.png",
                hyperparameters=params,
            )
        )
        ProjectManager.save(state)

        config = json.loads((state.folder / "config.json").read_text())
        assert config["layers"][0]["params"] == params

    def test_empty_hyperparameters_written_as_empty_dict(
        self, heightmap: Path, workspace: Path
    ) -> None:
        state = ProjectManager.create(heightmap, workspace)
        img = state.folder / "layers" / "rivers.png"
        img.write_bytes(_make_png())
        state.layers.append(
            LayerState(name="Rivers", status="ready", image_path="layers/rivers.png")
        )
        ProjectManager.save(state)

        config = json.loads((state.folder / "config.json").read_text())
        assert config["layers"][0]["params"] == {}


# ---------------------------------------------------------------------------
# AC3: Load — full state restored after round-trip
# ---------------------------------------------------------------------------


class TestProjectLoad:
    def _round_trip(
        self, heightmap: Path, workspace: Path, layer_names: list[str] | None = None
    ):
        state = ProjectManager.create(heightmap, workspace)
        for name in layer_names or []:
            img = state.folder / "layers" / f"{name.lower()}.png"
            img.write_bytes(_make_png())
            state.layers.append(
                LayerState(name=name, status="ready", image_path=f"layers/{name.lower()}.png")
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

    def test_restores_layer_image_paths(
        self, heightmap: Path, workspace: Path
    ) -> None:
        _, loaded = self._round_trip(heightmap, workspace, ["Rivers"])
        assert loaded.layers[0].image_path == "layers/rivers.png"

    def test_layer_images_exist_on_disk_after_reload(
        self, heightmap: Path, workspace: Path
    ) -> None:
        _, loaded = self._round_trip(heightmap, workspace, ["Rivers", "Biomes"])
        for layer in loaded.layers:
            assert (loaded.folder / layer.image_path).is_file()

    def test_heightmap_copy_exists_on_disk_after_reload(
        self, heightmap: Path, workspace: Path
    ) -> None:
        _, loaded = self._round_trip(heightmap, workspace)
        assert (loaded.folder / loaded.heightmap_path).is_file()

    def test_restores_layer_hyperparameters(
        self, heightmap: Path, workspace: Path
    ) -> None:
        params = {"algorithm": "simplex", "seed": 7, "iterations": 3}
        state = ProjectManager.create(heightmap, workspace)
        img = state.folder / "layers" / "rivers.png"
        img.write_bytes(_make_png())
        state.layers.append(
            LayerState(
                name="Rivers",
                status="ready",
                image_path="layers/rivers.png",
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
        # Write config without params key (simulates old format)
        config_path = state.folder / "config.json"
        config = json.loads(config_path.read_text())
        config["layers"] = [{"name": "Rivers", "status": "ready", "image": "layers/rivers.png"}]
        config_path.write_text(json.dumps(config), encoding="utf-8")
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

    def test_load_folder_without_config_raises_file_not_found(
        self, workspace: Path
    ) -> None:
        empty = workspace / "no_config"
        empty.mkdir()
        with pytest.raises(FileNotFoundError):
            ProjectManager.load(empty)

    def test_load_corrupt_json_raises_value_error(self, workspace: Path) -> None:
        folder = workspace / "corrupt"
        folder.mkdir()
        (folder / "config.json").write_text("{not valid json", encoding="utf-8")
        with pytest.raises(ValueError, match="Corrupt config"):
            ProjectManager.load(folder)

    def test_load_missing_required_key_raises_value_error(
        self, workspace: Path
    ) -> None:
        folder = workspace / "incomplete"
        folder.mkdir()
        (folder / "config.json").write_text(
            json.dumps({"version": 1}), encoding="utf-8"
        )
        with pytest.raises(ValueError, match="Invalid config structure"):
            ProjectManager.load(folder)

    def test_create_is_idempotent_for_existing_folder(
        self, heightmap: Path, workspace: Path
    ) -> None:
        ProjectManager.create(heightmap, workspace)
        # Second call on the same heightmap must not raise
        state2 = ProjectManager.create(heightmap, workspace)
        assert state2.folder.is_dir()
