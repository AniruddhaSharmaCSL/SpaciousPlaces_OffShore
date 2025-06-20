using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LaireonFramework
{
    public class DyamicExampleElement : ExampleElement
    {
        public override void Initialise(CharacterCarousel carousel, int index)
        {
            int realIndex = DynamicCarouselExample.Instance.unlockedCharacters[index];//read from the list instead. Otherwise the index will always be sequential!

            base.Initialise(carousel, realIndex);
        }
    }
}