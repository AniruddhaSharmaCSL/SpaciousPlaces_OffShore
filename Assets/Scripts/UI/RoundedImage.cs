using UnityEngine;
using UnityEngine.UI;

public class RoundedImage : Image
{
    [SerializeField] private float cornerRadius = 10f;

    protected override void OnPopulateMesh(VertexHelper vh)
    {
        vh.Clear();

        // Get rect dimensions
        Vector2 pivot = rectTransform.pivot;
        Vector2 size = rectTransform.rect.size;

        float width = size.x;
        float height = size.y;
        float xMin = -width * pivot.x;
        float yMin = -height * pivot.y;

        // Limit radius to half the smaller dimension
        cornerRadius = Mathf.Min(cornerRadius, Mathf.Min(width, height) / 2);

        // Create vertices for the rounded corners
        UIVertex vert = UIVertex.simpleVert;

        // Add vertices for main quad
        AddRoundedRect(vh, new Rect(xMin, yMin, width, height), cornerRadius);

        // Apply UV mapping
        ApplyUVs(vh);
    }

    private void AddRoundedRect(VertexHelper vh, Rect rect, float radius)
    {
        // Add vertices and triangles for the rounded rectangle
        // Number of segments per corner (more segments = smoother corners)
        const int segments = 8;

        // Add corners
        for (int i = 0; i < 4; i++)
        {
            float angle = i * 90f * Mathf.Deg2Rad;
            Vector2 center = new Vector2(
                i % 2 == 0 ? rect.xMin + radius : rect.xMax - radius,
                i < 2 ? rect.yMin + radius : rect.yMax - radius
            );

            AddCorner(vh, center, radius, angle, segments);
        }

        // Fill center
        AddQuad(vh,
            new Vector2(rect.xMin + radius, rect.yMin),
            new Vector2(rect.xMax - radius, rect.yMin),
            new Vector2(rect.xMax - radius, rect.yMax),
            new Vector2(rect.xMin + radius, rect.yMax)
        );

        // Fill sides
        AddQuad(vh,
            new Vector2(rect.xMin, rect.yMin + radius),
            new Vector2(rect.xMin + radius, rect.yMin + radius),
            new Vector2(rect.xMin + radius, rect.yMax - radius),
            new Vector2(rect.xMin, rect.yMax - radius)
        );

        AddQuad(vh,
            new Vector2(rect.xMax - radius, rect.yMin + radius),
            new Vector2(rect.xMax, rect.yMin + radius),
            new Vector2(rect.xMax, rect.yMax - radius),
            new Vector2(rect.xMax - radius, rect.yMax - radius)
        );
    }

    private void AddCorner(VertexHelper vh, Vector2 center, float radius, float startAngle, int segments)
    {
        float angleStep = (Mathf.PI / 2) / segments;
        Vector2 prevPoint = center + new Vector2(Mathf.Cos(startAngle), Mathf.Sin(startAngle)) * radius;

        for (int i = 1; i <= segments; i++)
        {
            float angle = startAngle + angleStep * i;
            Vector2 point = center + new Vector2(Mathf.Cos(angle), Mathf.Sin(angle)) * radius;

            AddTriangle(vh, center, prevPoint, point);
            prevPoint = point;
        }
    }

    private void AddQuad(VertexHelper vh, Vector2 v1, Vector2 v2, Vector2 v3, Vector2 v4)
    {
        AddTriangle(vh, v1, v2, v3);
        AddTriangle(vh, v1, v3, v4);
    }

    private void AddTriangle(VertexHelper vh, Vector2 v1, Vector2 v2, Vector2 v3)
    {
        int startIndex = vh.currentVertCount;

        UIVertex vert = UIVertex.simpleVert;

        vert.position = new Vector3(v1.x, v1.y, 0);
        vh.AddVert(vert);

        vert.position = new Vector3(v2.x, v2.y, 0);
        vh.AddVert(vert);

        vert.position = new Vector3(v3.x, v3.y, 0);
        vh.AddVert(vert);

        vh.AddTriangle(startIndex, startIndex + 1, startIndex + 2);
    }

    private void ApplyUVs(VertexHelper vh)
    {
        UIVertex vert = new UIVertex();
        for (int i = 0; i < vh.currentVertCount; i++)
        {
            vh.PopulateUIVertex(ref vert, i);

            // Convert position to UV coordinate
            Vector2 uv = new Vector2(
                (vert.position.x - rectTransform.rect.xMin) / rectTransform.rect.width,
                (vert.position.y - rectTransform.rect.yMin) / rectTransform.rect.height
            );

            vert.uv0 = uv;
            vh.SetUIVertex(vert, i);
        }
    }
}