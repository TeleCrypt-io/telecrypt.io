#!/usr/bin/env python3
"""Validate the exact generated route and metadata set used by Pages."""

from __future__ import annotations

import argparse
from pathlib import Path


REQUIRED_FILES = (
    "404.html",
    "privacy.txt",
    "robots.txt",
    "sitemap-index.xml",
    "sitemap-0.xml",
    "CNAME",
    "export/index.html",
    "export.txt",
)
REQUIRED_ROUTES = (
    "index.html",
    "about/index.html",
    "price/index.html",
    "privacy/index.html",
    "support/index.html",
    "technology/index.html",
    "llms/index.html",
)


def fail(message: str) -> None:
    raise SystemExit(f"generated site: {message}")


def validate(root: Path) -> None:
    if not root.is_dir():
        fail(f"site root is not a directory: {root}")
    for relative in (*REQUIRED_ROUTES, *REQUIRED_FILES):
        path = root / relative
        if not path.is_file() or path.stat().st_size == 0:
            fail(f"required non-empty file is missing: {relative}")
    robots_lines = (root / "robots.txt").read_text(encoding="utf-8").splitlines()
    if "Sitemap: https://www.telecrypt.io/sitemap-index.xml" not in robots_lines:
        fail("robots.txt does not contain the canonical sitemap line")
    if (root / "CNAME").read_text(encoding="utf-8").strip() != "www.telecrypt.io":
        fail("CNAME is not www.telecrypt.io")
    about_html = (root / "about/index.html").read_text(encoding="utf-8")
    if not about_html.lstrip().lower().startswith("<!doctype html>"):
        fail("about page must begin with a doctype")
    schema_marker = 'type="application/ld+json"'
    if about_html.count(schema_marker) != 1:
        fail("about page must contain exactly one JSON-LD document")
    head_start = about_html.find("<head")
    head_end = about_html.find("</head>")
    schema = about_html.find(schema_marker)
    if head_start < 0 or head_end < 0 or not head_start < schema < head_end:
        fail("about JSON-LD must be inside the document head")
    if '"@type":"AboutPage"' not in about_html or '"@type":"Organization"' not in about_html:
        fail("about JSON-LD is missing its page or organization type")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("root", type=Path)
    validate(parser.parse_args().root)
