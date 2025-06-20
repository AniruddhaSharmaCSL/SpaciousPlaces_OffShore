// ---------------------------------------
// Spectrum Visualizer code by Bad Raccoon
// (C)opyRight 2017/2018 By :
// Bad Raccoon / Creepy Cat / Barking Dog 
// ---------------------------------------

using UnityEngine;

public class SpectrumVis : MonoBehaviour 
{
	public SpectrumRendererDisplay[] cubes;
	public Color barColor;
	public float sizePower = 20;

	public enum axisStrech {dx, dy, dz, dyAndDz, all};
	public axisStrech stretchAxis=axisStrech.dy;

	public enum channelColour {red, green, blue, all};
	public channelColour currentChannel= channelColour.red;

	private float currentRed;
	private float currentGreen;
	private float currentBlue;

	public float colorPower = 12;

	void Start()
	{
		currentRed = barColor.r;
		currentGreen = barColor.g;
		currentBlue = barColor.b;
	}

	void Update () 
	{
		float framePower = Time.deltaTime * sizePower;

        for (int i = 0; i < cubes.Length; i++) {

			SpectrumRendererDisplay go = cubes[i];
			if(go == null)
				continue;
			float spect = SpectrumKernel.spects[i];

            // Save the old size
            Vector3 previousScale = go.transform.localScale;

			float powerPulse = spect * sizePower;
				
			// The new size
			if (stretchAxis == axisStrech.dx)
			{
				previousScale.x = Mathf.Lerp(previousScale.x, powerPulse, framePower);
			}
			else if (stretchAxis == axisStrech.dy)
			{
				previousScale.y = Mathf.Lerp(previousScale.y, powerPulse, framePower);
			}
            else if (stretchAxis == axisStrech.dz)
			{
				previousScale.z = Mathf.Lerp(previousScale.z, powerPulse, framePower);
			}
            else if (stretchAxis == axisStrech.dyAndDz)
			{
				previousScale.y = Mathf.Lerp(previousScale.y, powerPulse, framePower);
				previousScale.z = Mathf.Lerp(previousScale.z, powerPulse, framePower);
			}
            else if (stretchAxis == axisStrech.all)
			{
				previousScale.x = Mathf.Lerp(previousScale.x, powerPulse, framePower);
				previousScale.y = Mathf.Lerp(previousScale.y, powerPulse, framePower);
				previousScale.z = Mathf.Lerp(previousScale.z, powerPulse, framePower);
			}

			// Reset size
			go.transform.localScale = previousScale;
				
			// Colour change
			float colorPulse = spect * colorPower;

			if (currentChannel == channelColour.red) 
			{
				barColor.r =  currentRed + colorPulse;
			}
			else if (currentChannel == channelColour.green) 
			{
				barColor.g = currentGreen + colorPulse;
			}
			else if (currentChannel == channelColour.blue) 
			{
				barColor.b = currentBlue + colorPulse;
			}
			else if (currentChannel == channelColour.all) 
			{
				barColor.b = currentBlue + (colorPulse);
				barColor.g = currentGreen + (colorPulse);
				barColor.r = currentRed + (colorPulse);
			}
			go.SetColor(barColor);
		}
	}
}