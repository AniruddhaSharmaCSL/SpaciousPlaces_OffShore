//© Dicewrench Designs LLC 2024
//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using UnityEngine;

public class SpectrumShaderArray : MonoBehaviour
{
    [Header("Settings")]
    [SerializeField]
    private bool _clearOnDisable = true;

    [Header("Material Properties")]
    [SerializeField]
    [Tooltip("Global Shader Property name to write Spectrum data to.")]
    private string _arrayProperty;

    private int _arrayID = -1;
    private int ArrayID
    {
        get
        {
            if (_arrayID == -1)
                _arrayID = Shader.PropertyToID(_arrayProperty);
            return _arrayID;
        }
    }

    //unity array size max for normal instancing, since we aren't
    //sure of our future use cases we'll stick with this limitation
    private const int _ARRAY_SIZE = 1023;

    private float[] _array;

    private void Awake()
    {
        if( _array == null )
            _array = new float[_ARRAY_SIZE];
    }

    private void Update()
    {
        TransposeSpectrumToArray();
        SubmitToGlobal();
    }

    private void TransposeSpectrumToArray()
    {
        if(SpectrumKernel.spects == null)
        {
            Debug.LogWarning("Cannot Transpose Spectrum Array for Shader Globals.  Kernel spects is null.", this);
            return;
        }
        if(SpectrumKernel.spects.Length == 0 )
        {
            Debug.LogWarning("Cannot Transpose Spectrum Array for Shader Globals.  Kernel spects length is 0.", this);
            return;
        }
        if(_array == null )
        {
            Debug.LogWarning("Cannot Transpose Spectrum Array for Shader Globals.  Working Array not yet initialized.", this);
            return;
        }

        //the kernel always makes a spect array that's 1024... that should probably
        //be configurable or smart but we'll roll with it.

        //since that is always 1024 at this point, we'll just copy this over
        //to our max 1023 array, and do any quantization stuff on the GPU side
        //as that's potentially much faster math (without doing a gnarly burst/compute thing)

        int count = _array.Length;
        for(int a = 0; a < count; a++)
        {
            _array[a] = SpectrumKernel.spects[a];
        }    
    }

    private void SubmitToGlobal()
    {
        Shader.SetGlobalFloatArray(ArrayID, _array);
    }

    private void OnDisable()
    {
        if(_clearOnDisable)
        {
            int count = _array.Length;
            for (int a = 0; a < count; a++)
            {
                _array[a] = 0.0f;
            }
            SubmitToGlobal();
        }
    }
}
