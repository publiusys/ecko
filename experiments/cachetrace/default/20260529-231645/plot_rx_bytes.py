import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

FOLDER   = os.path.dirname(os.path.abspath(__file__))
OUTDIR   = FOLDER
SERVERS  = [f"server{i}" for i in range(2, 8)]   # server2 … server7
COLORS   = plt.cm.tab10.colors

# ── load all files ────────────────────────────────────────────────────────────
frames = {}
for srv in SERVERS:
    matches = [f for f in os.listdir(FOLDER) if f.startswith(srv) and f.endswith(".log")]
    if not matches:
        print(f"WARNING: no log file found for {srv}, skipping")
        continue
    path = os.path.join(FOLDER, matches[0])
    df   = pd.read_csv(path)
    df   = df[["timestamp", "rx_bytes"]].copy()
    df.sort_values("timestamp", inplace=True)
    df.reset_index(drop=True, inplace=True)

    # delta rx_bytes / delta time  →  bytes per second
    dt  = df["timestamp"].diff()          # seconds between samples (float)
    drx = df["rx_bytes"].diff()           # bytes received since last sample
    df["rx_bytes_per_sec"] = drx / dt     # rate in B/s

    # drop first row (NaN) and any negative deltas (counter reset artefacts)
    df = df.iloc[1:].copy()
    df = df[df["rx_bytes_per_sec"] >= 0]

    frames[srv] = df
    print(f"{srv}: {len(df)} samples  "
          f"peak={df['rx_bytes_per_sec'].max()/1e6:.1f} MB/s  "
          f"mean={df['rx_bytes_per_sec'].mean()/1e6:.1f} MB/s")

# ── Figure 1: per-server rx_bytes/sec ────────────────────────────────────────
fig1, ax1 = plt.subplots(figsize=(12, 5))
for idx, (srv, df) in enumerate(frames.items()):
    ax1.plot(df["timestamp"], df["rx_bytes_per_sec"] / 1e6,
             label=srv, color=COLORS[idx], linewidth=1.2, alpha=0.85)

ax1.set_xlabel("Experiment time (s)")
ax1.set_ylabel("rx_bytes / sec (MB/s)")
ax1.set_title("Per-server rx throughput  —  20260529-231645")
ax1.legend(loc="upper left", fontsize=9)
ax1.yaxis.set_major_formatter(ticker.FormatStrFormatter("%.1f MB/s"))
ax1.grid(True, linestyle="--", alpha=0.4)
ax1.set_xlim(left=0)
ax1.set_ylim(bottom=0)
fig1.tight_layout()
out1 = os.path.join(OUTDIR, "rx_bytes_per_server.png")
fig1.savefig(out1, dpi=150)
print(f"saved → {out1}")

# ── Figure 2: total rx_bytes/sec (sum across all servers) ────────────────────
# Align on a common 1-second integer grid, sum, then plot
all_series = []
for srv, df in frames.items():
    s = df.set_index("timestamp")["rx_bytes_per_sec"]
    s.index = s.index.round(0)
    all_series.append(s)

combined = pd.concat(all_series, axis=1)
combined.columns = list(frames.keys())
combined.sort_index(inplace=True)
combined["total"] = combined.sum(axis=1)

fig2, ax2 = plt.subplots(figsize=(12, 5))
ax2.plot(combined.index, combined["total"] / 1e6,
         color="steelblue", linewidth=1.5, label="total (all servers)")
ax2.fill_between(combined.index, combined["total"] / 1e6,
                 alpha=0.15, color="steelblue")

ax2.set_xlabel("Experiment time (s)")
ax2.set_ylabel("rx_bytes / sec (MB/s)")
ax2.set_title("Total cluster rx throughput (servers 2–7)  —  20260529-231645")
ax2.legend(fontsize=9)
ax2.yaxis.set_major_formatter(ticker.FormatStrFormatter("%.1f MB/s"))
ax2.grid(True, linestyle="--", alpha=0.4)
ax2.set_xlim(left=0)
ax2.set_ylim(bottom=0)

# annotate peak
peak_t   = combined["total"].idxmax()
peak_val = combined["total"].max() / 1e6
ax2.annotate(f"peak {peak_val:.1f} MB/s",
             xy=(peak_t, peak_val),
             xytext=(peak_t + 5, peak_val * 0.92),
             arrowprops=dict(arrowstyle="->", color="black"),
             fontsize=9)

fig2.tight_layout()
out2 = os.path.join(OUTDIR, "rx_bytes_total.png")
fig2.savefig(out2, dpi=150)
print(f"saved → {out2}")
