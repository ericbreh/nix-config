{
  plugins.flutter-tools = {
    enable = true;
    lazyLoad.enable = true;
    lazyLoad.settings = {ft = "dart";};
    settings = {
      lsp = {
        settings = {
          lineLength = 100;
          showTodos = true;
          completeFunctionCalls = true;
        };
      };
    };
  };
}
