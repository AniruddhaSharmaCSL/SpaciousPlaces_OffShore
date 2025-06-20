using SpaciousPlaces;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


// Layout script used to lay out the chimes in Editor. Adjust and re-run if rearranging chimes.
[ExecuteAlways] 

public class LayoutChimes : MonoBehaviour
{
    private float xSpacing = 0.01729f;

    private List<GameObject> ChimeBases = new List<GameObject>();

    private List<GameObject> ChimesOrig = new List<GameObject>();

     [SerializeField] private bool needsLayout = false;

    // Update is called once per frame
    void Update()
    {
        if (needsLayout)
        {
            ChimeBases.Clear();
            ChimesOrig.Clear();

            foreach (Transform t in transform)
            {
                if (t.gameObject.name.Contains("ChimeBase"))
                {
                    ChimeBases.Add(t.gameObject);
                }

                if (t.gameObject.name.Contains("Chime_"))
                {
                    ChimesOrig.Add(t.gameObject);
                }
            }

            var i = 0;
            var pitchIndex = 0;

            Transform startingTop = transform;
            Vector3 startingAnchor = Vector3.zero;

            foreach (GameObject chimeBase in ChimeBases)
            {
                Transform top;
                GameObject chime;
                GameObject chimesCollider;

                foreach (Transform child in chimeBase.transform)
                {
                    if (child.gameObject.name == "Top")
                    {
                        if (i == 0)
                        {
                            startingTop = child;
                        }

                        top = child;
                        top.transform.position = new Vector3(startingTop.position.x + xSpacing * i, startingTop.position.y, startingTop.position.z);
                    }

                    if (child.gameObject.name == "Chime")
                    {
                        chime = child.gameObject;
                        // mesh
                        GameObject chimeOrig = ChimesOrig[i];

                        var meshFilter = chime.GetComponent<MeshFilter>();
                        meshFilter.mesh = chimeOrig.GetComponent<MeshFilter>().sharedMesh;

                        //hinge
                        var hinge = chime.GetComponent<HingeJoint>();

                        if (i == 0)
                        {
                            startingAnchor = hinge.anchor;
                        }   

                        hinge.anchor = new Vector3(startingAnchor.x - xSpacing * i, startingAnchor.y, startingAnchor.z);

                        var trigger = chime.GetComponent<InstrumentCollision>();
                        trigger.offsetPitch = pitchIndex - 1;
                        pitchIndex++;
                        if (pitchIndex >= 5)
                        {
                            pitchIndex = 0;
                        }

                        foreach (Transform child2 in child.transform)
                        {
                            if (child2.gameObject.name == "ChimesCollider")
                            {
                                chimesCollider = child2.gameObject;

                                var colliders = chimesCollider.GetComponentsInChildren<BoxCollider>();

                                var origCollider = chimeOrig.GetComponent<BoxCollider>();

                                foreach (BoxCollider collider in colliders)
                                {
                                    collider.center = origCollider.center;
                                    collider.size = origCollider.size;
                                }
                            }
                        }
                    }
                }
                i++;
            }
        }
        needsLayout = false;
    }
}
