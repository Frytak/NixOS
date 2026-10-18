{ inputs }:
final: prev: {
    btop = prev.btop.override { cudaSupport = true; };

    bottles = prev.bottles.override { removeWarningPopup = true; };

    clapper = prev.clapper.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or []) ++ [
            prev.gst_all_1.gst-plugins-good
            prev.gst_all_1.gst-plugins-bad
            prev.gst_all_1.gst-plugins-ugly
            prev.gst_all_1.gst-libav
        ];
    });

    # Packages from unstable
    unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
    };
}
