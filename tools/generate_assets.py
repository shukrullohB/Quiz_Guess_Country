# Python
import json
from pathlib import Path

ASSETS_DIR = Path("assets/images")
OUT_FILE = Path("assets_manifest.json")

def collect_images():
    exts = {".png", ".jpg", ".jpeg", ".webp"}
    return sorted(str(p) for p in ASSETS_DIR.rglob("*") if p.suffix.lower() in exts)

def main():
    images = collect_images()
    OUT_FILE.write_text(json.dumps({"images": images}, indent=2), encoding="utf-8")
    print(f"Found {len(images)} images. Manifest written to {OUT_FILE}")

if __name__ == "__main__":
    main()
