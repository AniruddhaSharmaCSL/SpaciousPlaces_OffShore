//© Dicewrench Designs LLC 2024
//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using UnityEngine;

[RequireComponent(typeof(Renderer))]
public class SpectrumRendererDisplay : MonoBehaviour
{
    private Renderer _renderer;
    private Renderer Renderer
    {
        get
        {
            if( _renderer == null )
                _renderer = GetComponent<Renderer>();
            return _renderer;
        }
    }

    private MaterialPropertyBlock _block;
    private MaterialPropertyBlock Block
    {
        get
        {
            if(_block == null )
                _block = new MaterialPropertyBlock();
            return _block;
        }
    }

    public void SetColor(Color color)
    {
        if (Renderer == null)
            return;

        Block.SetColor("_Color", color);
        Block.SetColor("_BaseColor", color);
        Block.SetColor("_TintColor", color);
        Renderer.SetPropertyBlock(Block);
    }
}
