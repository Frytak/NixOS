{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.ollama;
in

{
    options.modules.system.ollama = {
        enable = lib.mkEnableOption "Ollama local LLM server (CUDA)";

        contextLength = lib.mkOption {
            description = "Default context window (tokens) the Ollama server advertises.";
            type = lib.types.str;
            default = "32768";
            example = "16384";
        };
    };

    config = lib.mkIf moduleConfig.enable {
        services.ollama = {
            enable = true;
            package = pkgs.unstable.ollama-cuda;
            host = "127.0.0.1";
            port = 11434;
            environmentVariables.OLLAMA_CONTEXT_LENGTH = moduleConfig.contextLength;
        };
    };
}
