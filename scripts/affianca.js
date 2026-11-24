// Mette Skim nella metà destra dello schermo e kitty in quella sinistra,
// poi riporta il focus su kitty. Lanciato da nvim alla prima apertura del PDF.
// Uso: osascript -l JavaScript affianca.js
ObjC.import("AppKit");
function run() {
  const screen = $.NSScreen.mainScreen;
  const full = screen.frame, vis = screen.visibleFrame;      // coordinate Cocoa (origine in basso)
  const top = full.size.height - (vis.origin.y + vis.size.height);
  const x = vis.origin.x, w = Math.floor(vis.size.width / 2), h = vis.size.height;

  const skim = Application("Skim");
  if (skim.windows.length > 0) {
    skim.windows[0].bounds = { x: x + w, y: top, width: vis.size.width - w, height: h };
  }
  try {   // kitty non è scriptabile: serve System Events (permesso Accessibilità a kitty)
    const k = Application("System Events").processes.byName("kitty").windows[0];
    k.position = [x, top];
    k.size = [w, h];
  } catch (e) {
    return "kitty-no";
  }
  Application("kitty").activate();
  return "ok";
}
