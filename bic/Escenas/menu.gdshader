shader_type canvas_item;

// --- AJUSTA ESTOS VALORES EN EL INSPECTOR ---
uniform vec4 border_color : source_color = vec4(1.0, 0.843, 0.0, 1.0); // Color Dorado
uniform float corner_radius : hint_range(0.0, 0.5, 0.01) = 0.04;
uniform float border_thickness : hint_range(0.0, 0.5, 0.01) = 0.02;
// ---------------------------------------------

// Función matemática para un rectángulo redondeado
float sdf_rounded_rect(vec2 uv, vec2 size, float radius) {
    vec2 d = abs(uv) - size + vec2(radius);
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - radius;
}

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    vec2 centered_uv = UV - 0.5; // Centra las coordenadas (0,0 es el centro)

    // Calcula la distancia al borde exterior (imagen + borde)
    float dist_outer = sdf_rounded_rect(centered_uv, vec2(0.5 - corner_radius), corner_radius);
    
    // Calcula la distancia al borde interior (solo la imagen)
    float dist_inner = sdf_rounded_rect(centered_uv, vec2(0.5 - corner_radius - border_thickness), corner_radius);

    // Antialias para bordes suaves
    float aa = fwidth(dist_outer) * 0.5;

    // Máscara para la forma completa (imagen + borde)
    float mask_outer = 1.0 - smoothstep(-aa, aa, dist_outer);
    
    // Máscara para solo la imagen interior
    float mask_inner = 1.0 - smoothstep(-aa, aa, dist_inner);

    // El borde es la resta de la máscara exterior menos la interior
    float border_mask = mask_outer - mask_inner;

    // Mezcla el color original con el color del borde
    vec4 final_color = mix(original_color, border_color, border_mask);

    // Aplica la transparencia final (la forma exterior)
    final_color.a = original_color.a * mask_outer;
    
    COLOR = final_color;
}