// This is really short version of CAS based on AMD presentation (https://gpuopen.com/wp-content/uploads/2019/07/FidelityFX-CAS.pptx)
#include "common.hlsli"

float sharpening_intensity;

float4 main(float2 texcoord : TEXCOORD0, float4 hpos : SV_Position) : SV_Target
{
    // fetch a 3x3 neighborhood around the pixel 'e',
    //  a b c
    //  d(e)f
    //  g h i
    
    float3 a = s_image.SampleLevel(smp_rtlinear, texcoord, 0.0, int2(-1, -1)).xyz; a *= rcp(1.0f + a);
    float3 b = s_image.SampleLevel(smp_rtlinear, texcoord, 0.0, int2(0, -1)).xyz; b *= rcp(1.0f + b);
    float3 c = s_image.SampleLevel(smp_rtlinear, texcoord, 0.0, int2(1, -1)).xyz; c *= rcp(1.0f + c);
	
    float3 d = s_image.SampleLevel(smp_rtlinear, texcoord, 0.0, int2(-1, 0)).xyz; d *= rcp(1.0f + d);
    float3 g = s_image.SampleLevel(smp_rtlinear, texcoord, 0.0, int2(-1, 1)).xyz; g *= rcp(1.0f + g);
	
    float3 e = s_image.SampleLevel(smp_rtlinear, texcoord, 0.0).xyz; e *= rcp(1.0f + e);
	
    float3 f = s_image.SampleLevel(smp_rtlinear, texcoord, 0.0, int2(1, 0)).xyz; f *= rcp(1.0f + f);
    float3 h = s_image.SampleLevel(smp_rtlinear, texcoord, 0.0, int2(0, 1)).xyz; h *= rcp(1.0f + h);
    float3 i = s_image.SampleLevel(smp_rtlinear, texcoord, 0.0, int2(1, 1)).xyz; i *= rcp(1.0f + i);

	// Soft min and max.
	//  a b c             b
	//  d e f * 0.5  +  d e f * 0.5
	//  g h i             h
    // These are 2.0x bigger (factored out the extra multiply).
    float3 mnRGB = min(min(min(d, e), min(f, b)), h);
    float3 mnRGB2 = min(mnRGB, min(min(a, c), min(g, i)));
    mnRGB += mnRGB2;

    float3 mxRGB = max(max(max(d, e), max(f, b)), h);
    float3 mxRGB2 = max(mxRGB, max(max(a, c), max(g, i)));
    mxRGB += mxRGB2;

    // Smooth minimum distance to signal limit divided by smooth max.
    float3 rcpMRGB = rcp(mxRGB);
    float3 ampRGB = saturate(min(mnRGB, 2.0 - mxRGB) * rcpMRGB);    
    
    // Shaping amount of sharpening.
    ampRGB = rsqrt(ampRGB);
    
	float Contrast = 1.0f; //sharpening_intensity; //1.0f;
	float Sharpening = sharpening_intensity; //sharpening_intensity;
	
    float peak = -3.0 * Contrast + 8.0;
    float3 wRGB = -rcp(ampRGB * peak);

    float3 rcpWeightRGB = rcp(4.0 * wRGB + 1.0);

    //                          0 w 0
    //  Filter shape:           w 1 w
    //                          0 w 0  
	
    float3 window = (b + d) + (f + h);
    float3 outColor = saturate((window * wRGB + e) * rcpWeightRGB);
    
	outColor = lerp(e, outColor, Sharpening);
	
	return float4(outColor * rcp(max(0.00001f, 1.0 - outColor)), 1.0f);
}
