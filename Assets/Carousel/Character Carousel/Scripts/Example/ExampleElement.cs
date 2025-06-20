using UnityEngine;
using System.Collections;
using UnityEngine.UI;

namespace LaireonFramework
{
    /// <summary>
    /// This is where you would add your own data!
    /// </summary>
    public class ExampleElement : CarouselElement
    {
        [Tooltip("If true numbers will go from 1 to screenCount left to right. If false then numbers will be screenCount to 1")]
        public bool ascendingNumbers;

        [Tooltip("If this is true then slider values won't be reset once they get stacked on the sides. If its false the bars are reset and the animation is shown again when you view the screen")]
        public bool resetHiddenScreens;

        public Text text;
        public Image characterImage;

        public Sprite[] characterImages;//this is just a quick example of using an image for each character. You probably want to move and read this from a manager somewhere else

        public string titlePrefix;

        public Slider powerSlider, armourSlider, speedSlider, capacitySlider;
        public Text powerText, armourText, speedText, capacityText;

        float power, armour, speed, capacity;

        public TransitionalObject statAnimation;//this is used to make the bars animate in once they are viewed the first time. Its placed on a sub object to avoid having two transitions on the same object which is dangerous!

        //void Start()//don't implement this unless you include the following lines as well
        //{
        //    transform = base.transform as RectTransform;
        //    transition.SetState(TransitionalObjects.BaseTransition.TransitionState.TransitionIn);//show this transition is waiting since we will control it manually
        //}

        /// <summary>
        /// Set your data for each element here. DO NOT implement start. If you have to you must copy what is in the parent class
        /// </summary>
        /// <param name="carousel"></param>
        /// <param name="index"></param>
        public override void Initialise(CharacterCarousel carousel, int index)
        {
            base.Initialise(carousel, index);

            if (ascendingNumbers)
                text.text = titlePrefix + " " + (carousel.maxScreens - index);//here we set the title text with the screen number. E.G Ship 1
            else
                text.text = titlePrefix + " " + (index + 1);//this sets the numbers in the opposite order

            if (index < characterImages.Length)//check if you added more screens but not more images
                characterImage.sprite = characterImages[index];//an example to show chanaging individual character images
            else
                characterImage.sprite = characterImages[characterImages.Length - 1];

            if (powerSlider != null)
            {
                powerSlider.value = Random.Range(0, 100);//set some random values for this ships stats
                armourSlider.value = Random.Range(0, 100);
                speedSlider.value = Random.Range(0, 100);
                capacitySlider.value = Random.Range(0, 100);

                power = powerSlider.value;
                armour = armourSlider.value;
                speed = speedSlider.value;
                capacity = capacitySlider.value;
            }
        }

        /// <summary>
        /// Updates the text beside the stat bars as the stat bars animate
        /// </summary>
        void UpdateText()
        {
            powerText.text = ((int)powerSlider.value).ToString();
            armourText.text = ((int)armourSlider.value).ToString();
            speedText.text = ((int)speedSlider.value).ToString();
            capacityText.text = ((int)capacitySlider.value).ToString();
        }

        public override void UpdatePosition(float currentPosition)
        {
            base.UpdatePosition(currentPosition);

            if (statAnimation != null)
            {
                float value = statAnimation.TransitionPercentage;

                if (currentPosition > 2)//stacked on the right
                {
                    if (resetHiddenScreens)
                        statAnimation.TriggerFadeOutIfActive();
                }
                else if (currentPosition > 0.9 && currentPosition < 1.1)//middle section. We give a gap for people dragging the UI rather than clicking and snapping
                    statAnimation.TriggerTransitionIfIdle();
                else if (currentPosition < 0)//left stack
                {
                    if (resetHiddenScreens)
                        statAnimation.TriggerFadeOutIfActive();// value = 0;
                }

                powerSlider.value = power * value;//animate our sliders to match the animation of the screen
                armourSlider.value = armour * value;
                speedSlider.value = speed * value;
                capacitySlider.value = capacity * value;

                UpdateText();
            }
        }
    }
}