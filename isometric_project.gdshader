shader_type spatial;
render_mode unshaded;

uniform float iso_angle = 0.63; // ~35.264 degrees in radians

void vertex() {
    // Apply isometric rotation around Y-axis
    float cos_y = cos(iso_angle);
    float sin_y = sin(iso_angle);
    mat3 rot_y = mat3(
        vec3(cos_y, 0.0, -sin_y),
        vec3(0.0, 1.0, 0.0),
        vec3(sin_y, 0.0, cos_y)
    );
    
    // Apply 45-degree rotation around Z-axis
    float cos_z = cos(0.785398); // 45 degrees in radians
    float sin_z = sin(0.785398);
    mat3 rot_z = mat3(
        vec3(cos_z, -sin_z, 0.0),
        vec3(sin_z, cos_z, 0.0),
        vec3(0.0, 0.0, 1.0)
    );
    
    // Combine rotations and apply to vertex
    VERTEX = (rot_z * rot_y * VERTEX);
    
    // Scale the Z-axis to flatten the perspective
    VERTEX.z *= 0.1;
}

void fragment() {
    // Use vertex color or texture as needed
    ALBEDO = vec3(1.0, 1.0, 1.0); // White color, replace with your desired color or texture
}