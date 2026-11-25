-- Impostazioni extra di kitty per tema (oltre a sfondo e testo, presi dal tema stesso).
-- theme.lua rilegge questo file a ogni cambio tema: le modifiche valgono anche
-- nei nvim già aperti, senza riavviarli.
return {
  mrrobot = {
    -- font dei PC IBM in modalità testo/DOS (BigBlue Terminal, versione Plus con accenti e icone).
    -- Altri provati: "3270NFM-SemCond" (25 pt), "PressStart2P-Regular" (15 pt), "HeavyDataNF" (20 pt)
    "font_family      BigBlueTermPlusNFM",
    -- nel font DOS la ~ è un trattino in alto (˜): la prendo dal 3270, dove sta a metà riga
    "symbol_map U+007E 3270 Nerd Font Mono",
    "bold_font        auto",
    "italic_font      auto",
    "bold_italic_font auto",
    "font_size        18.0",
    "modify_font cell_width 100%",   -- il font è già stretto: lettere attaccate
    "modify_font cell_height 100%",  -- il font è già senza interlinea; sotto il 100% la _ (in fondo alla cella) viene tagliata
    -- cursore a blocco lampeggiante, come un vecchio terminale
    "cursor_shape block",
    "cursor_blink_interval 0.5",
    "cursor_stop_blinking_after 0",
    "cursor #ffffff", "cursor_text_color #000000",
    "selection_background #e6e6e6", "selection_foreground #000000",
    "color0 #000000", "color8 #5c5c5c", "color1 #b3b3b3", "color9 #ffffff",
    "color2 #e6e6e6", "color10 #ffffff", "color3 #b3b3b3", "color11 #ffffff",
    "color4 #8a8a8a", "color12 #ffffff", "color5 #b3b3b3", "color13 #ffffff",
    "color6 #8a8a8a", "color14 #ffffff", "color7 #e6e6e6", "color15 #ffffff",
  },
  phosphor = {
    -- Spleen 8x16: lettere quadrate come nello screenshot di riferimento, ma con più pixel
    -- (ha accenti e grassetto finto di kitty). A 18 pt i pixel sono un filo meno netti che a 16/24:
    -- nitido solo a multipli di 8 (8 = minuscolo, 24 = grande).
    -- Prima: "Pixel4x7-Regular" (ricostruito dallo screenshot, glifi in ~/.config/nvim/fonts) a 14 pt.
    "font_family      Spleen8x16",
    "bold_font        auto",
    "italic_font      Spleen8x16",
    "bold_italic_font auto",
    "font_size        18.0",
    "modify_font cell_width 100%",
    "modify_font cell_height 100%",
    "text_composition_strategy legacy",   -- niente ammorbidimento: pixel pieni
    "cursor_shape block",
    "cursor_blink_interval 0.5",
    "cursor_stop_blinking_after 0",
    "cursor #88ff88", "cursor_text_color #000000",
    "selection_background #1a3a1a", "selection_foreground #ccffa9",
    "color0 #000000", "color8 #446644", "color1 #b87457", "color9 #ff5f5f",
    "color2 #88ff88", "color10 #aaff66", "color3 #aaff66", "color11 #ccffa9",
    "color4 #88aaff", "color12 #6688bb", "color5 #9988dd", "color13 #9988dd",
    "color6 #66cccc", "color14 #aacccc", "color7 #ccffa9", "color15 #ffffff",
  },
  paper = {
    -- JetBrains Mono (versione NL = senza legature); se manca kitty ripiega da solo su un altro monospace
    "font_family      JetBrainsMonoNL Nerd Font Mono",
    "bold_font        auto",
    "italic_font      auto",
    "bold_italic_font auto",
    "font_size        14.0",
    "modify_font cell_width 100%",
    "modify_font cell_height 115%",   -- interlinea ~1.15
    "disable_ligatures always",
    "text_composition_strategy platform",
    "cursor_shape beam",
    "cursor_blink_interval 0",
    "cursor #1E1E1E", "cursor_text_color #F4F3EF",
    "selection_background #DDDAD2", "selection_foreground none",
    "color0 #1E1E1E", "color8 #8A8A8A", "color1 #3A3A3A", "color9 #1E1E1E",
    "color2 #3A3A3A", "color10 #1E1E1E", "color3 #555555", "color11 #3A3A3A",
    "color4 #3A3A3A", "color12 #1E1E1E", "color5 #555555", "color13 #3A3A3A",
    "color6 #555555", "color14 #3A3A3A", "color7 #DDDAD2", "color15 #F4F3EF",
  },
}
