#include "common.hlsli"

Texture2D s_base0;
Texture2D s_base1;
Texture2D s_noise;

Texture2D s_grad0;
Texture2D s_grad1;

uniform float4 c_brightness;
uniform float4 c_colormap;

// Pixel
float4 main(p_postpr I) : SV_Target
{
    float3 t_0 = s_base0.Sample(smp_rtlinear, I.Tex0);
    float3 t_1 = s_base1.Sample(smp_rtlinear, I.Tex1);
    float3 image_o = (t_0 + t_1) * .5f;

    float grad_i = dot(image_o, 0.3333f);

    float3 image0 = s_grad0.Sample(smp_rtlinear, float2(grad_i, 0.5f));
    float3 image1 = s_grad1.Sample(smp_rtlinear, float2(grad_i, 0.5f));
	
    float3 image = lerp(image0, image1, c_colormap.y);
    image = lerp(image_o, image, c_colormap.x);

    float gray = dot(image, I.Gray);
    image = lerp(gray, image, I.Gray.w);

    float4 t_noise = s_noise.Sample(smp_linear, I.Tex2);
    float3 noised = image * t_noise * 2.0f;
	
    image = lerp(noised, image, I.Color.w);
    image = (image * I.Color + c_brightness) * 2.0f;

    image = deband_color(image, I.Tex0);
    return float4(image, 1.0h);
}
