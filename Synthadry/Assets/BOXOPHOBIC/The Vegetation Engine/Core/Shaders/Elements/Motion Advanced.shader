// Made with Amplify Shader Editor v1.9.1.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Elements/Default/Motion Advanced"
{
	Properties
	{
		[StyledBanner(Motion Advanced Element)]_Banner("Banner", Float) = 0
		[StyledMessage(Info, Use the Motion Advanced elements to add noise to the motion direction. Element Texture A is used as alpha mask. Particle Alpha is used as Element Intensity multiplier. The noise is animated in the element forward direction and it is updated with particles or in play mode only., 0,0)]_Message("Message", Float) = 0
		[StyledCategory(Render Settings)]_CategoryRender("[ Category Render ]", Float) = 0
		_ElementIntensity("Render Intensity", Range( 0 , 1)) = 1
		[StyledMessage(Warning, When using all layers the Global Volume will create one render texture for each layer to render the elements. Try using fewer layers when possible., _ElementLayerWarning, 1, 10, 10)]_ElementLayerWarning("Render Layer Warning", Float) = 0
		[StyledMessage(Info, When using a higher Layer number the Global Volume will create more render textures to render the elements. Try using fewer layers when possible., _ElementLayerMessage, 1, 10, 10)]_ElementLayerMessage("Render Layer Message", Float) = 0
		[StyledMask(TVELayers, Default 0 Layer_1 1 Layer_2 2 Layer_3 3 Layer_4 4 Layer_5 5 Layer_6 6 Layer_7 7 Layer_8 8, 0, 0)]_ElementLayerMask("Render Layer", Float) = 1
		[StyledCategory(Element Settings)]_CategoryElement("[ Category Element ]", Float) = 0
		[NoScaleOffset][StyledTextureSingleLine]_MainTex("Element Texture", 2D) = "white" {}
		[Space(10)][StyledRemapSlider(_MainTexMinValue, _MainTexMaxValue, 0, 1)]_MainTexRemap("Element Remap", Vector) = (0,0,0,0)
		[HideInInspector]_MainTexMinValue("Element Min", Range( 0 , 1)) = 0
		[HideInInspector]_MainTexMaxValue("Element Max", Range( 0 , 1)) = 1
		[StyledVector(9)]_MainUVs("Element UVs", Vector) = (1,1,0,0)
		[StyledTextureSingleLine]_NoiseTex("Noise Texture", 2D) = "gray" {}
		[StyledRemapSlider(_NoiseMinValue, _NoiseMaxValue, 0, 1, 10, 0)]_NoiseRemap("Noise Remap", Vector) = (0,0,0,0)
		[HideInInspector]_NoiseMinValue("Noise Min", Range( 0 , 1)) = 0
		[HideInInspector]_NoiseMaxValue("Noise Max", Range( 0 , 1)) = 1
		_NoiseIntensityValue("Noise Intensity", Range( 0 , 1)) = 0
		_NoiseScaleValue("Noise Scale", Range( 0 , 20)) = 1
		_NoiseSpeedValue("Noise Speed", Range( 0 , 2)) = 1
		[Space(10)]_MotionPower("Wind Power", Range( 0 , 1)) = 0
		[StyledMessage(Info, The Particle Velocity mode requires the particle to have custom vertex streams for Velocity and Speed set after the UV stream under the particle Renderer module. , _ElementDirectionMode, 40, 10, 0)]_ElementDirectionMessage("Element Direction Message", Float) = 0
		[Enum(Element Forward,10,Element Texture,20,Particle Translate,30,Particle Velocity,40)][Space(10)]_ElementDirectionMode("Direction Mode", Float) = 20
		[Space(10)][StyledToggle]_ElementInvertMode("Use Inverted Element Direction", Float) = 0
		[StyledCategory(Fading Settings)]_CategoryFade("[ Category Fade ]", Float) = 0
		[HDR][StyledToggle]_ElementRaycastMode("Enable Raycast Fading", Float) = 0
		[StyledToggle]_ElementVolumeFadeMode("Enable Volume Edge Fading", Float) = 0
		[HideInInspector]_RaycastFadeValue("Raycast Fade Mask", Float) = 1
		[Space(10)][StyledLayers()]_RaycastLayerMask("Raycast Layer", Float) = 1
		_RaycastDistanceEndValue("Raycast Distance", Float) = 2
		[ASEEnd][StyledCategory(Advanced Settings)]_CategoryAdvanced("[ Category Advanced ]", Float) = 0
		[HideInInspector]_ElementLayerValue("Legacy Layer Value", Float) = -1
		[HideInInspector]_InvertX("Legacy Invert Mode", Float) = 0
		[HideInInspector]_ElementFadeSupport("Legacy Edge Fading", Float) = 0
		[HideInInspector]_IsVersion("_IsVersion", Float) = 800
		[HideInInspector]_IsElementShader("_IsElementShader", Float) = 1
		[HideInInspector]_element_direction_mode("_element_direction_mode", Vector) = (0,0,0,0)
		[HideInInspector]_IsMotionElement("_IsMotionElement", Float) = 1
		[HideInInspector]_render_colormask("_render_colormask", Float) = 15

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "PreviewType"="Plane" "DisableBatching"="True" }
	LOD 0

		CGINCLUDE
		#pragma target 4.5
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha, One One
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			// Element Type Define
			#define TVE_IS_MOTION_ELEMENT


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half _IsMotionElement;
			uniform half _render_colormask;
			uniform half _Banner;
			uniform half _Message;
			uniform half _ElementLayerMask;
			uniform half _IsElementShader;
			uniform float _ElementFadeSupport;
			uniform half _ElementLayerValue;
			uniform half _RaycastDistanceEndValue;
			uniform half4 _NoiseRemap;
			uniform float _InvertX;
			uniform half4 _MainTexRemap;
			uniform half _RaycastLayerMask;
			uniform half _CategoryRender;
			uniform half _CategoryElement;
			uniform half _CategoryAdvanced;
			uniform float _IsVersion;
			uniform half _ElementLayerMessage;
			uniform half _ElementLayerWarning;
			uniform half _ElementDirectionMessage;
			uniform half _ElementRaycastMode;
			uniform half _CategoryFade;
			uniform float _ElementDirectionMode;
			uniform half4 _element_direction_mode;
			uniform sampler2D _MainTex;
			uniform half4 _MainUVs;
			uniform half _MainTexMinValue;
			uniform half _MainTexMaxValue;
			uniform float _ElementInvertMode;
			uniform sampler2D _NoiseTex;
			uniform half _NoiseScaleValue;
			uniform half _NoiseSpeedValue;
			uniform half _NoiseMinValue;
			uniform half _NoiseMaxValue;
			uniform half _NoiseIntensityValue;
			uniform half _MotionPower;
			uniform float _ElementIntensity;
			uniform half4 TVE_ColorsCoords;
			uniform half4 TVE_ExtrasCoords;
			uniform half4 TVE_MotionCoords;
			uniform half4 TVE_VertexCoords;
			uniform half TVE_ElementsFadeValue;
			uniform float _ElementVolumeFadeMode;
			uniform half _RaycastFadeValue;
			half4 IS_ELEMENT( half4 Colors, half4 Extras, half4 Motion, half4 Vertex )
			{
				#if defined (TVE_IS_COLORS_ELEMENT)
				return Colors;
				#elif defined (TVE_IS_EXTRAS_ELEMENT)
				return Extras;
				#elif defined (TVE_IS_MOTION_ELEMENT)
				return Motion;
				#elif defined (TVE_IS_VERTEX_ELEMENT)
				return Vertex;
				#else
				return Colors;
				#endif
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1 = v.ase_texcoord;
				o.ase_color = v.color;
				o.ase_texcoord2 = v.ase_texcoord1;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
				half2 Direction_Transform1406_g22567 = (( mul( unity_ObjectToWorld, float4( float3(0,0,1) , 0.0 ) ).xyz / ase_objectScale )).xz;
				float4 tex2DNode17_g22567 = tex2D( _MainTex, ( ( ( 1.0 - i.ase_texcoord1.xy ) * (_MainUVs).xy ) + (_MainUVs).zw ) );
				float temp_output_7_0_g22569 = _MainTexMinValue;
				float4 temp_cast_2 = (temp_output_7_0_g22569).xxxx;
				float4 break469_g22567 = saturate( ( ( tex2DNode17_g22567 - temp_cast_2 ) / ( _MainTexMaxValue - temp_output_7_0_g22569 ) ) );
				half MainTex_R73_g22567 = break469_g22567.r;
				half MainTex_G265_g22567 = break469_g22567.g;
				float3 appendResult274_g22567 = (float3((MainTex_R73_g22567*2.0 + -1.0) , 0.0 , (MainTex_G265_g22567*2.0 + -1.0)));
				float3 break281_g22567 = ( mul( unity_ObjectToWorld, float4( appendResult274_g22567 , 0.0 ) ).xyz / ase_objectScale );
				float2 appendResult1403_g22567 = (float2(break281_g22567.x , break281_g22567.z));
				half2 Direction_Texture284_g22567 = appendResult1403_g22567;
				float2 appendResult1404_g22567 = (float2(i.ase_color.r , i.ase_color.g));
				half2 Direction_VertexColor1150_g22567 = (appendResult1404_g22567*2.0 + -1.0);
				float2 appendResult1382_g22567 = (float2(i.ase_texcoord1.z , i.ase_texcoord2.x));
				half2 Direction_Velocity1394_g22567 = ( appendResult1382_g22567 / i.ase_texcoord2.y );
				float2 temp_output_1452_0_g22567 = ( ( _element_direction_mode.x * Direction_Transform1406_g22567 ) + ( _element_direction_mode.y * Direction_Texture284_g22567 ) + ( _element_direction_mode.z * Direction_VertexColor1150_g22567 ) + ( _element_direction_mode.w * Direction_Velocity1394_g22567 ) );
				half Element_InvertMode489_g22567 = _ElementInvertMode;
				float2 lerpResult1468_g22567 = lerp( temp_output_1452_0_g22567 , -temp_output_1452_0_g22567 , Element_InvertMode489_g22567);
				half2 Direction_Advanced1454_g22567 = lerpResult1468_g22567;
				float2 appendResult1347_g22567 = (float2(WorldPosition.x , WorldPosition.z));
				half Noise_Scale892_g22567 = _NoiseScaleValue;
				half2 Noise_Coords1409_g22567 = ( -( appendResult1347_g22567 * 0.1 ) * Noise_Scale892_g22567 );
				float2 temp_output_3_0_g22584 = Noise_Coords1409_g22567;
				float2 temp_output_21_0_g22584 = Direction_Advanced1454_g22567;
				half Noise_Speed898_g22567 = _NoiseSpeedValue;
				float temp_output_15_0_g22584 = ( _Time.y * Noise_Speed898_g22567 );
				float temp_output_23_0_g22584 = frac( temp_output_15_0_g22584 );
				float4 lerpResult39_g22584 = lerp( tex2D( _NoiseTex, ( temp_output_3_0_g22584 + ( temp_output_21_0_g22584 * temp_output_23_0_g22584 ) ) ) , tex2D( _NoiseTex, ( temp_output_3_0_g22584 + ( temp_output_21_0_g22584 * frac( ( temp_output_15_0_g22584 + 0.5 ) ) ) ) ) , ( abs( ( temp_output_23_0_g22584 - 0.5 ) ) / 0.5 ));
				half Noise_Min893_g22567 = _NoiseMinValue;
				float temp_output_7_0_g22585 = Noise_Min893_g22567;
				float4 temp_cast_5 = (temp_output_7_0_g22585).xxxx;
				half Noise_Max894_g22567 = _NoiseMaxValue;
				half2 Noise_Advanced1427_g22567 = (saturate( ( ( lerpResult39_g22584 - temp_cast_5 ) / ( Noise_Max894_g22567 - temp_output_7_0_g22585 ) ) )).rg;
				half Noise_Intensity965_g22567 = _NoiseIntensityValue;
				float2 lerpResult1435_g22567 = lerp( (Direction_Advanced1454_g22567*0.5 + 0.5) , Noise_Advanced1427_g22567 , Noise_Intensity965_g22567);
				half Motion_Power1000_g22567 = _MotionPower;
				float3 appendResult1436_g22567 = (float3(lerpResult1435_g22567 , Motion_Power1000_g22567));
				half3 Final_MotionAdvanced_RGB1438_g22567 = appendResult1436_g22567;
				half MainTex_A74_g22567 = break469_g22567.a;
				half4 Colors37_g22574 = TVE_ColorsCoords;
				half4 Extras37_g22574 = TVE_ExtrasCoords;
				half4 Motion37_g22574 = TVE_MotionCoords;
				half4 Vertex37_g22574 = TVE_VertexCoords;
				half4 localIS_ELEMENT37_g22574 = IS_ELEMENT( Colors37_g22574 , Extras37_g22574 , Motion37_g22574 , Vertex37_g22574 );
				float4 temp_output_35_0_g22575 = localIS_ELEMENT37_g22574;
				float temp_output_7_0_g22581 = TVE_ElementsFadeValue;
				float2 temp_cast_6 = (temp_output_7_0_g22581).xx;
				float2 temp_output_851_0_g22567 = saturate( ( ( abs( (( (temp_output_35_0_g22575).zw + ( (temp_output_35_0_g22575).xy * (WorldPosition).xz ) )*2.002 + -1.001) ) - temp_cast_6 ) / ( 1.0 - temp_output_7_0_g22581 ) ) );
				float2 break852_g22567 = ( temp_output_851_0_g22567 * temp_output_851_0_g22567 );
				float lerpResult842_g22567 = lerp( 1.0 , ( 1.0 - saturate( ( break852_g22567.x + break852_g22567.y ) ) ) , _ElementVolumeFadeMode);
				half Fade_EdgeMask656_g22567 = lerpResult842_g22567;
				half Element_Intensity56_g22567 = ( _ElementIntensity * i.ase_color.a * Fade_EdgeMask656_g22567 * _RaycastFadeValue );
				half Final_MotionAdvanced_A1439_g22567 = ( MainTex_A74_g22567 * Element_Intensity56_g22567 );
				float4 appendResult1463_g22567 = (float4(Final_MotionAdvanced_RGB1438_g22567 , Final_MotionAdvanced_A1439_g22567));
				
				
				finalColor = appendResult1463_g22567;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "TVEShaderElementGUI"
	
	Fallback Off
}
/*ASEBEGIN
Version=19102
Node;AmplifyShaderEditor.FunctionNode;177;-640,-1280;Inherit;False;Define Element Motion;66;;19669;6eebc31017d99e84e811285e6a5d199d;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-640,-1152;Half;False;Property;_render_colormask;_render_colormask;68;1;[HideInInspector];Create;True;0;0;0;True;0;False;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-320,-1024;Float;False;True;-1;2;TVEShaderElementGUI;0;5;BOXOPHOBIC/The Vegetation Engine/Elements/Default/Motion Advanced;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;4;1;False;;1;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;True;True;True;True;True;True;0;False;_render_colormask;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;2;False;;True;0;False;;True;False;0;False;;0;False;;True;4;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;DisableBatching=True=DisableBatching;True;5;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-352,-1280;Half;False;Property;_Banner;Banner;0;0;Create;True;0;0;0;True;1;StyledBanner(Motion Advanced Element);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-224,-1280;Half;False;Property;_Message;Message;1;0;Create;True;0;0;0;True;1;StyledMessage(Info, Use the Motion Advanced elements to add noise to the motion direction. Element Texture A is used as alpha mask. Particle Alpha is used as Element Intensity multiplier. The noise is animated in the element forward direction and it is updated with particles or in play mode only., 0,0);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;403;-639,-1024;Inherit;False;Base Element;2;;22567;0e972c73cae2ee54ea51acc9738801d0;6,477,2,478,0,145,3,481,2,576,1,491,1;0;1;FLOAT4;0
WireConnection;0;0;403;0
ASEEND*/
//CHKSM=74B41CA75962E059406E1E83E0152174E6788C14