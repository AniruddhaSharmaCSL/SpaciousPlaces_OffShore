using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace SpaciousPlaces
{
    public class RequireShaderAttribute : PropertyAttribute
    {
        public string ShaderName { get; private set; }

        public RequireShaderAttribute(string shaderName)
        {
            ShaderName = shaderName;
        }
    }
}