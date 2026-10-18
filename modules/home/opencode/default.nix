{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.opencode;

    ollamaUrl = "http://127.0.0.1:11434/v1";

    limit = {
        context = 32768;
        output = 8192;
    };
in

{
    options.modules.home.opencode = {
        enable = lib.mkEnableOption "opencode with local Ollama models";
    };

    config = lib.mkIf moduleConfig.enable {
        programs.opencode = {
            enable = true;
            package = pkgs.unstable.opencode;

            settings.provider = {
                ollama = {
                    npm = "@ai-sdk/openai-compatible";
                    name = "Ollama (coding)";
                    options.baseURL = ollamaUrl;
                    models = {
                        "qwen3:4b" = {
                            name = "Qwen3 4B (local, fast)";
                            inherit limit;
                        };
                        "qwen2.5-coder:7b" = {
                            name = "Qwen2.5-Coder 7B (local)";
                            inherit limit;
                        };
                        "gpt-oss:20b" = {
                            name = "GPT-OSS 20B (local)";
                            inherit limit;
                        };
                    };
                };

                "ollama-chat" = {
                    npm = "@ai-sdk/openai-compatible";
                    name = "Ollama (uncensored)";
                    options.baseURL = ollamaUrl;
                    models = {
                        "dolphin3:8b" = {
                            name = "Dolphin 3 8B (local, uncensored)";
                            inherit limit;
                        };
                        "huihui_ai/gpt-oss-abliterated:20b" = {
                            name = "GPT-OSS 20B abliterated (local, uncensored)";
                            inherit limit;
                        };
                    };
                };
            };
        };
    };
}
