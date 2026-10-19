# Local models (BBM only)

Ollama runs as a CUDA systemd service on BBM (`modules.system.ollama`), listening on
`127.0.0.1:11434`. Models are stored under `/var/lib/ollama/models`. Download them
manually with `ollama pull` — nothing is pulled automatically on rebuild.

opencode reads them from two providers (config in `modules/home/opencode`):

- **Ollama (coding)** — reliable tool-calling, used for agent work.
- **Ollama (uncensored)** — abliterated models for open-ended chat.

## Coding / agent

| Model | Pull | Size | Use |
|---|---|---|---|
| `qwen3:4b` | `ollama pull qwen3:4b` | ~2.5 GB | quick tasks, small edits, fast |
| `qwen2.5-coder:7b` | `ollama pull qwen2.5-coder:7b` | ~4.7 GB | everyday coding, fits 8 GB VRAM |
| `gpt-oss:20b` | `ollama pull gpt-oss:20b` | ~14 GB | large agent tasks (default pick) |

## Uncensored chat

| Model | Pull | Size | Use |
|---|---|---|---|
| `dolphin3:8b` | `ollama pull dolphin3:8b` | ~5 GB | general uncensored chat |
| `huihui_ai/gpt-oss-abliterated:20b` | `ollama pull huihui_ai/gpt-oss-abliterated:20b` | ~14 GB | large uncensored chat |

Community (abliterated) tags rotate and publish requants. If the exact tag above is
missing, list what exists and pick a ~Q4 build:

```
ollama pull huihui_ai/gpt-oss-abliterated:20b-q4_K_M   # or :20b-q3_K_M, etc.
```

Optional mid uncensored pick: `ollama pull huihui_ai/qwen3-abliterated:14b` (~9 GB).

## Using them

- Quick chat in a terminal: `ollama run gpt-oss:20b`
- In opencode: `/models` → pick under **Ollama (coding)** or **Ollama (uncensored)**.
- List what is installed: `ollama list`
- Remove a model: `ollama rm <model>`

## Saving / exporting sessions

Sessions live in opencode's local DB, not in this repo. To save one:

```
opencode export <sessionID> > session.json   # add --sanitize to redact secrets
```

- Find the id: `opencode session list`
- Re-import later: `opencode import session.json`
- Remove one: `opencode session delete <sessionID>`

## Context / memory

The server advertises a 32768-token context (`modules.system.ollama.contextLength`) and
opencode's model entries match it. On 8 GB VRAM the KV cache grows with context; if a
20B model runs out of memory, lower `contextLength` and rebuild.

The GPU is a PRIME-offloaded RTX 3070 Ti (8 GB); larger models spill to system RAM
(32 GB) via expert-offload, which is slower but usable.
