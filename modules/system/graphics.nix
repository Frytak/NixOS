{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.graphics;
in

{
    options.modules.system.graphics = {
        enable = lib.mkEnableOption "GPU drivers (NVIDIA with PRIME offload)";

        nvidiaBusId = lib.mkOption {
            description = "PCI bus ID of the NVIDIA GPU.";
            type = lib.types.str;
            default = "PCI:1:0:0";
        };

        intelBusId = lib.mkOption {
            description = "PCI bus ID of the Intel GPU, for Intel + NVIDIA PRIME.";
            type = lib.types.nullOr lib.types.str;
            default = null;
        };

        amdgpuBusId = lib.mkOption {
            description = "PCI bus ID of the AMD GPU, for AMD + NVIDIA PRIME.";
            type = lib.types.nullOr lib.types.str;
            default = null;
        };
    };

    config = lib.mkIf moduleConfig.enable {
        services.xserver.videoDrivers = [ "nvidia" ];

        environment.variables = {
            NIXOS_OZONE_WL = 1;
            GBM_BACKEND = "nvidia-drm";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            WLR_NO_HARDWARE_CURSORS = "1";
            LIBVA_DRIVER_NAME = "nvidia";
            NVD_BACKEND = "direct";
            MOZ_DISABLE_RDD_SANDBOX = "1";
        };

        hardware.graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = with pkgs; [ nvidia-vaapi-driver libvdpau-va-gl ];
        };

        hardware.nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.production;
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = true;
            nvidiaSettings = true;

            prime = {
                offload.enable = true;
                offload.enableOffloadCmd = true;
                nvidiaBusId = moduleConfig.nvidiaBusId;
            }
            // lib.optionalAttrs (moduleConfig.intelBusId != null) {
                intelBusId = moduleConfig.intelBusId;
            }
            // lib.optionalAttrs (moduleConfig.amdgpuBusId != null) {
                amdgpuBusId = moduleConfig.amdgpuBusId;
            };
        };
    };
}
