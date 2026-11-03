import importlib.machinery
import importlib.util
import io
from pathlib import Path
import unittest
from unittest.mock import patch


loader = importlib.machinery.SourceFileLoader(
    "gscctl", str(Path(__file__).with_name("gscctl"))
)
spec = importlib.util.spec_from_loader(loader.name, loader)
gscctl = importlib.util.module_from_spec(spec)
loader.exec_module(gscctl)

URL = "https://bmux.cc/articles/bmux-0-1-12/"
PROPERTY = "sc-domain:bmux.cc"
LINK = "https://search.google.com/search-console/inspect?resource_id=sc-domain%3Abmux.cc&id=test"


class PropertyFallbackTests(unittest.TestCase):
    def test_property_selection_requires_domain_boundary(self):
        self.assertEqual(gscctl.select_property([PROPERTY], URL), PROPERTY)
        self.assertTrue(gscctl.property_matches(PROPERTY, "https://www.bmux.cc/"))
        with self.assertRaises(gscctl.PropertyNotFound):
            gscctl.select_property([PROPERTY], "https://otherbmux.cc/")

    def test_index_uses_existing_browser_inspection_and_closes_on_success(self):
        with (
            patch("sys.argv", ["gscctl", "index", URL]),
            patch("sys.stdout", new_callable=io.StringIO) as output,
            patch("sys.stderr", new_callable=io.StringIO),
            patch.object(gscctl, "resolve", side_effect=gscctl.PropertyNotFound()),
            patch.object(gscctl, "resolve_in_bmux", return_value=(PROPERTY, LINK, "pane", "window")),
            patch.object(gscctl, "open_in_bmux") as open_browser,
            patch.object(gscctl, "request_indexing", return_value=("Indexing requested", True)) as request,
            patch.object(gscctl, "close_bmux_window") as close,
        ):
            self.assertEqual(gscctl.main(), 0)
            open_browser.assert_not_called()
            request.assert_called_once_with("pane", reindex=False)
            close.assert_called_once_with("window")
            self.assertIn("Indexing requested", output.getvalue())

    def test_api_failure_is_preserved(self):
        with (
            patch("sys.argv", ["gscctl", "index", URL]),
            patch.object(gscctl, "resolve", side_effect=gscctl.GscctlError("API unavailable")),
            patch.object(gscctl, "resolve_in_bmux") as fallback,
        ):
            with self.assertRaisesRegex(gscctl.GscctlError, "API unavailable"):
                gscctl.main()
            fallback.assert_not_called()


if __name__ == "__main__":
    unittest.main()
