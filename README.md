# ericbreh's nix-config

```
     _   ___    _      
    +o\  \  \  / \     
    \oo\  \  \/  /     
  ,oo+oo+oo\   ,/ +\   
 <oooooooooo\  \ /os;  
     /``/    \  ,oo/   
,─~─'  /      \,oooooo,
\__   ;s      /oo/sss>`
  /  /so\____/ss/____  
 `, / \oo\   ```     / 
  \/ /sooo\─~.  .─~─`  
    /so/\oo\  \  \     
    \o/  \s+\  \_/     

```

NixOS config focused on simplicity and ease of use. Follows the dendritic pattern.

- **Standalone Features:** Every file or directory under `modules/features/` is an isolated feature that never imports another feature.

- **Unified Exports:** Each feature exports a standard NixOS module. If it requires Home Manager options, the NixOS module injects them via `home-manager.sharedModules`.

- **Flat Directory Structure:** Features remain as single `.nix` files in `modules/features/` by default, becoming a directory when they require supporting files.

This allows NixOS hosts to maintain a single list of features in its `configuration.nix` which could include any combination of features without worrying about duplicate imports.
