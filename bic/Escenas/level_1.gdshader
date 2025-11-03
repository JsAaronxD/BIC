shader_type canvas_item;

// --- AJUSTA ESTE VALOR ---
// Números más altos = más borroso.
// Comienza con 0.005 y sube o baja desde ahí.
uniform float blur_amount : hint_range(0.0, 0.01, 0.001) = 0.003; 

void fragment() {
	vec4 blurred_color = vec4(0.0);
	
	// Muestreo de 9 píxeles (un cuadrado de 3x3 alrededor del píxel)
	// (Usamos TEXTURE y UV, que se refieren a la textura del propio nodo)
	blurred_color += texture(TEXTURE, UV + vec2(-blur_amount, -blur_amount));
	blurred_color += texture(TEXTURE, UV + vec2(0.0, -blur_amount));
	blurred_color += texture(TEXTURE, UV + vec2(blur_amount, -blur_amount));
	
	blurred_color += texture(TEXTURE, UV + vec2(-blur_amount, 0.0));
	blurred_color += texture(TEXTURE, UV); // El píxel central
	blurred_color += texture(TEXTURE, UV + vec2(blur_amount, 0.0));
	
	blurred_color += texture(TEXTURE, UV + vec2(-blur_amount, blur_amount));
	blurred_color += texture(TEXTURE, UV + vec2(0.0, blur_amount));
	blurred_color += texture(TEXTURE, UV + vec2(blur_amount, blur_amount));
	
	// Saca el promedio de los 9 píxeles
	blurred_color /= 9.0;
	
	// Combina el color borroso con la transparencia original de la imagen
	COLOR = vec4(blurred_color.rgb, blurred_color.a * COLOR.a);
}