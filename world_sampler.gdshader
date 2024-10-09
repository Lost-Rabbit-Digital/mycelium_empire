shader_type spatial;

uniform sampler2D tilemap_texture;

void fragment() {
    vec4 color = texture(tilemap_texture, UV).rgba;
    ALBEDO = color.rgb;
    ALPHA = color.a;
}