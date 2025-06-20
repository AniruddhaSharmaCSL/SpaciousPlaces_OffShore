//© Dicewrench Designs LLC 2021-2023

//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using UnityEditor;

namespace DWD.Editor
{
   public class HideUnlessDrawer : HideMaterialPropertyDrawerBase
   {
      protected override bool EvaluateShouldShow(MaterialEditor editor)
      {
         if (_keywords != null && _keywords.Length > 0)
         {
            if (MaterialHasKeyword(editor))
               return true;
            else
               return false;
         }
         else
            return false;
      }

      public HideUnlessDrawer()
      {
         _keywords = new string[] { "" };
      }

      public HideUnlessDrawer(params string[] s)
      {
         int count = s.Length;
         this._keywords = new string[count];
         for (int i = 0; i < count; i++)
         {
            this._keywords[i] = new string(s[i]);
         }
      }
   }
}