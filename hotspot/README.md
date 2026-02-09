# Windows Hotspot Toggle (Plan A Extension)

This extends the Plan A scheduled-task approach with **start** and **stop** options.

## Script
`ToggleHotspot.ps1` accepts a required `-Action` parameter:

- `Start`: turns on Mobile Hotspot
- `Stop`: turns off Mobile Hotspot

Example usage:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\ToggleHotspot.ps1" -Action Start
powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\ToggleHotspot.ps1" -Action Stop
```

> Copy `ToggleHotspot.ps1` to a known path (e.g., `C:\Scripts\ToggleHotspot.ps1`).

## Scheduled Task: Start on boot
1. Open **Task Scheduler** → **Create Task**.
2. **General**: check **Run with highest privileges**.
3. **Triggers**: **At startup** (optional: add 30–60s delay).
4. **Actions**:
   - Program/script: `powershell.exe`
   - Add arguments:
     ```
     -ExecutionPolicy Bypass -File "C:\Scripts\ToggleHotspot.ps1" -Action Start
     ```

## Scheduled Task: Stop on demand
To create a manual toggle task (e.g., run from a shortcut):

1. **Create Task** (or **Create Basic Task**).
2. **General**: check **Run with highest privileges**.
3. **Triggers**: **On demand** only (no trigger).
4. **Actions**:
   - Program/script: `powershell.exe`
   - Add arguments:
     ```
     -ExecutionPolicy Bypass -File "C:\Scripts\ToggleHotspot.ps1" -Action Stop
     ```

You can then create a desktop shortcut to run the task manually.

## Windows 11 Pro test checklist (manual)
This repository cannot simulate a real Windows 11 Pro environment. Use the checklist
below to validate the script on your device:

1. Confirm OS: **Settings → System → About** shows **Windows 11 Pro**.
2. Ensure **Mobile hotspot** is available in **Settings → Network & internet**.
3. Copy the script to `C:\Scripts\ToggleHotspot.ps1`.
4. Run in an elevated PowerShell:
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\ToggleHotspot.ps1" -Action Start
   ```
5. Verify hotspot turns on, then run:
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\ToggleHotspot.ps1" -Action Stop
   ```
6. If step 4 fails, connect to a network first and retry (the script requires a
   valid internet connection profile).
7. The script only allows **Start** when the active connection is **Ethernet**
   (IANA interface type 6). If you are on Wi-Fi, it will refuse to start.
