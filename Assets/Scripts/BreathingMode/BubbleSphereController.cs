using UnityEngine;

public class BubbleSphereController : MonoBehaviour
{

    [Header("Box Breathing")]
    [Tooltip("Seconds for each phase (inhale, hold, exhale, hold)")]
    [SerializeField] private float edgeSeconds = 4f;

    [SerializeField]
    private AnimationCurve _animationCurve;

    private bool _isInitialized = false;

    private Vector3 _initialScale = Vector3.one;

    private Vector3 InitialScale
    {
        get
        {
            if (_isInitialized == false)
            {
                _isInitialized = true;
                _initialScale = transform.localScale;
            }
            return _initialScale;
        }
    }

    private float _cachedLength = -1.0f;
    private float CachedLength
    {
        get
        {
            if (_cachedLength == -1.0f)
            {
                _cachedLength = _animationCurve.keys[_animationCurve.keys.Length - 1].time;
            }
            return _cachedLength;
        }
    }

    private float _elapsedTime = 0.0f;
    private float _cycleTime;
    private Vector3 _workingScale = Vector3.one;

    private float Frac(float val)
    {
        return val - Mathf.Floor(val);
    }
    /*
    private void Update()
    {
        _elapsedTime += Time.deltaTime;
        _cycleTime = CachedLength * Frac(_elapsedTime / CachedLength);
        SetScale(_animationCurve.Evaluate(_cycleTime));
    }
    */

    private void Update()
    {
        _elapsedTime += Time.deltaTime;

        // 4 edges (inhale-hold-exhale-hold)
        float fullCycle = edgeSeconds * 4f;
        float t = _elapsedTime % fullCycle;   // time inside the current cycle
        float scale;

        if (t < edgeSeconds)                            // 1) inhale
        {
            float p = t / edgeSeconds;                  // 0-1
            scale = _animationCurve.Evaluate(p);      // curve goes min → max
        }
        else if (t < 2f * edgeSeconds)                  // 2) hold (full)
        {
            scale = _animationCurve.Evaluate(1f);       // stay at max
        }
        else if (t < 3f * edgeSeconds)                  // 3) exhale
        {
            float p = (t - 2f * edgeSeconds) / edgeSeconds; // 0-1
            scale = _animationCurve.Evaluate(1f - p); // curve backwards max → min
        }
        else                                            // 4) hold (empty)
        {
            scale = _animationCurve.Evaluate(0f);       // stay at min
        }

        SetScale(scale);
    }



    private void SetScale(float scale)
    {
        _workingScale.x = scale;
        _workingScale.y = scale;
        _workingScale.z = scale;
        transform.localScale = _workingScale;
    }
}
