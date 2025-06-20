using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;
using static ModeManager;
using static UnityEngine.InputSystem.InputAction;

public class ModeManager : Singleton<ModeManager>
{
    public UnityEvent<GameMode> OnGameModeChanged = new UnityEvent<GameMode>();

    public static ModeManager instance;

    [SerializeField] private Toggle InstrumentToggle;
    [SerializeField] private Toggle CreativeToggle;
    [SerializeField] private Toggle BreathingToggle;

    public enum GameMode { Instrument, Creative, Breathing }

    private GameMode currentMode = GameMode.Instrument;

    /* ─────────────────── PUBLIC API (bound in the Input System) ─────────────────── */

    // ❶  Y-button   → toggles Breathing / Instrument
    public void ToggleBreathingMode(CallbackContext context)          // bind to “Y”
    {
        ToggleBreathingMode();
    }
    public void ToggleBreathingMode()          // bind to “Y”
    {
        //  Instrument  → Breathing
        //  Creative    → Breathing
        //  Breathing   → Instrument
        SetGameMode(currentMode == GameMode.Breathing
                    ? GameMode.Instrument
                    : GameMode.Breathing);
    }

    // ❷  B-button   → toggles Creative / Instrument
    public void ToggleCreativeMode(CallbackContext context)           // bind to “B”
    {
        ToggleCreativeMode();
    }
    public void ToggleCreativeMode()           // bind to “B”
    {
        //  Instrument  → Creative
        //  Breathing   → Creative
        //  Creative    → Instrument
        SetGameMode(currentMode == GameMode.Creative
                    ? GameMode.Instrument
                    : GameMode.Creative);
    }

    public void CycleModes(CallbackContext context) {
        CycleModes();
    }
    public void CycleModes() {
        GameMode nextMode = (GameMode)(((int)currentMode + 1) % System.Enum.GetValues(typeof(GameMode)).Length);
        ControlPanelManager.Instance.setGameModeText(nextMode.ToString());
        SetGameMode(nextMode);
    }

    /* ─────────────────── INTERNALS ─────────────────── */

    public GameMode CurrentMode => currentMode;

    private void OnDestroy() => OnGameModeChanged.RemoveAllListeners();

    private void SetGameMode(GameMode mode)
    {
        if (mode == currentMode) return;     // nothing to do

        currentMode = mode;
        OnGameModeChanged.Invoke(currentMode);

        // keep UI toggles in sync (optional)
        if (InstrumentToggle) InstrumentToggle.SetIsOnWithoutNotify(mode == GameMode.Instrument);
        if (CreativeToggle) CreativeToggle.SetIsOnWithoutNotify(mode == GameMode.Creative);
        if (BreathingToggle) BreathingToggle.SetIsOnWithoutNotify(mode == GameMode.Breathing);
    }
}
