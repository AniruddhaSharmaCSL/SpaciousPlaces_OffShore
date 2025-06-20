using System.Collections;
using System.Text;
using UnityEngine;
using Unity.Profiling;

#if URP_PRESENT
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
#endif

public class ProfilerStats : MonoBehaviour
{
    // ────────────────────── Profiler recorders ───────────────────────────
    private ProfilerRecorder triangleRecorder;
    private ProfilerRecorder drawCallsRecorder;
    private ProfilerRecorder verticesRecorder;

    // ────────────────────── Overlay target ───────────────────────────────
    public TMPro.TextMeshProUGUI statOverlay;

    // ────────────────────── FPS helper ───────────────────────────────────
    private int framesCount;
    private float framesTime;
    private float lastFPS;

    // ────────────────────── MSAA info ────────────────────────────────────
    private int eyeMsaa = -1;   // runtime truth
    private int qualMsaa = -1;   // Project Settings ▸ Quality
    private int urpMsaa = -1;   // URP Asset value (if URP_PRESENT)

    // --------------------------------------------------------------------
    private void Start()
    {
        if (statOverlay == null)
            statOverlay = GetComponent<TMPro.TextMeshProUGUI>();

        // Build-time values we can fetch immediately
        qualMsaa = QualitySettings.antiAliasing;

#if URP_PRESENT
        if (GraphicsSettings.currentRenderPipeline is UniversalRenderPipelineAsset urp)
            urpMsaa = urp.msaaSampleCount;
#endif
        // Runtime value needs one frame so OVR can finish creating eye textures
        StartCoroutine(FetchEyeMsaaNextFrame());
    }

    private IEnumerator FetchEyeMsaaNextFrame()
    {
        yield return new WaitForEndOfFrame();
        eyeMsaa = UnityEngine.XR.XRSettings.eyeTextureDesc.msaaSamples;
    }

    // --------------------------------------------------------------------
    private void OnEnable()
    {
        triangleRecorder = ProfilerRecorder.StartNew(ProfilerCategory.Render, "Triangles Count");
        drawCallsRecorder = ProfilerRecorder.StartNew(ProfilerCategory.Render, "Draw Calls Count");
        verticesRecorder = ProfilerRecorder.StartNew(ProfilerCategory.Render, "Vertices Count");
    }

    private void OnDisable()
    {
        triangleRecorder.Dispose();
        drawCallsRecorder.Dispose();
        verticesRecorder.Dispose();
    }

    // --------------------------------------------------------------------
    private void Update()
    {
        // ── FPS calc ─────────────────────────────────────────────────────
        framesCount++;
        framesTime += Time.unscaledDeltaTime;
        if (framesTime > 0.5f)
        {
            lastFPS = framesCount / framesTime;
            framesCount = 0;
            framesTime = 0f;
        }

        // ── Build overlay text ───────────────────────────────────────────
        var sb = new StringBuilder(128);
        sb.AppendLine($"FPS:    {lastFPS:F1}");
        sb.AppendLine($"Verts:  {verticesRecorder.LastValue / 1000}k");
        sb.AppendLine($"Tris:   {triangleRecorder.LastValue / 1000}k");
        sb.AppendLine($"Calls:  {drawCallsRecorder.LastValue}");

        // MSAA section (only once we’ve read the runtime value)
        if (eyeMsaa > 0)
        {
            sb.AppendLine();
            sb.AppendLine($"MSAA  (eye) : {eyeMsaa}×");
            if (qualMsaa > 0) sb.AppendLine($"MSAA Quality : {qualMsaa}×");
            if (urpMsaa > 0) sb.AppendLine($"MSAA URP     : {urpMsaa}×");
        }

        statOverlay.text = sb.ToString();
    }
}

