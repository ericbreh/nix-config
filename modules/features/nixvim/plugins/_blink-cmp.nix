{
  plugins.luasnip.enable = true;

  plugins.blink-cmp = {
    enable = true;
    setupLspCapabilities = true;

    settings = {
      keymap.preset = "super-tab";

      appearance.nerd_font_variant = "mono";

      completion.documentation = {
        auto_show = true;
        auto_show_delay_ms = 500;
      };

      sources.default = ["lsp" "path" "snippets"];

      snippets.preset = "luasnip";
      fuzzy.implementation = "lua";
      signature.enabled = true;
    };
  };
}
