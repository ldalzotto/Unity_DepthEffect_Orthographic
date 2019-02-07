using UnityEngine;

public class DepthEnabled : MonoBehaviour
{
    private void Start()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }
}
