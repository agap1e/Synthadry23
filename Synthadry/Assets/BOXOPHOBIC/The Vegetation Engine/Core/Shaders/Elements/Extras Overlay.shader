// Made with Amplify Shader Editor v1.9.1.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Elements/Default/Extras Overlay"
{
	Properties
	{
		[StyledBanner(Overlay Element)]_Banner("Banner", Float) = 0
		[StyledMessage(Info, Use the Overlay elements to control the overlay effect on vegetation or static props. Element Texture R and Particle Color R are used as value multipliers. Element Texture A and Particle Color A are used as element as alpha mask., 0,0)]_Message("Message", Float) = 0
		[StyledCategory(Render Settings)]_CategoryRender("[ Category Render ]", Float) = 0
		_ElementIntensity("Render Intensity", Range( 0 , 1)) = 1
		[StyledMessage(Warning, When using all layers the Global Volume will create one render texture for each layer to render the elements. Try using fewer layers when possible., _ElementLayerWarning, 1, 10, 10)]_ElementLayerWarning("Render Layer Warning", Float) = 0
		[StyledMessage(Info, When using a higher Layer number the Global Volume will create more render textures to render the elements. Try using fewer layers when possible., _ElementLayerMessage, 1, 10, 10)]_ElementLayerMessage("Render Layer Message", Float) = 0
		[StyledMask(TVELayers, Default 0 Layer_1 1 Layer_2 2 Layer_3 3 Layer_4 4 Layer_5 5 Layer_6 6 Layer_7 7 Layer_8 8, 0, 0)]_ElementLayerMask("Render Layer", Float) = 1
		[Enum(Constant,0,Seasons,1)]_ElementMode("Render Mode", Float) = 0
		[StyledCategory(Element Settings)]_CategoryElement("[ Category Element ]", Float) = 0
		[NoScaleOffset][StyledTextureSingleLine]_MainTex("Element Texture", 2D) = "white" {}
		[Space(10)][StyledRemapSlider(_MainTexMinValue, _MainTexMaxValue, 0, 1)]_MainTexRemap("Element Remap", Vector) = (0,0,0,0)
		[HideInInspector]_MainTexMinValue("Element Min", Range( 0 , 1)) = 0
		[HideInInspector]_MainTexMaxValue("Element Max", Range( 0 , 1)) = 1
		[StyledVector(9)]_MainUVs("Element UVs", Vector) = (1,1,0,0)
		_MainValue("Element Value", Range( 0 , 1)) = 1
		_AdditionalValue1("Winter Value", Range( 0 , 1)) = 1
		_AdditionalValue2("Spring Value", Range( 0 , 1)) = 1
		_AdditionalValue3("Summer Value", Range( 0 , 1)) = 1
		_AdditionalValue4("Autumn Value", Range( 0 , 1)) = 1
		[StyledRemapSlider(_NoiseMinValue, _NoiseMaxValue, 0, 1, 10, 0)]_NoiseRemap("Noise Remap", Vector) = (0,0,0,0)
		[StyledMessage(Info, The Particle Velocity mode requires the particle to have custom vertex streams for Velocity and Speed set after the UV stream under the particle Renderer module. , _ElementDirectionMode, 40, 10, 0)]_ElementDirectionMessage("Element Direction Message", Float) = 0
		[Enum(Element Forward,10,Element Texture,20,Particle Translate,30,Particle Velocity,40)][Space(10)]_ElementDirectionMode("Direction Mode", Float) = 20
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
		[HideInInspector]_IsExtrasElement("_IsExtrasElement", Float) = 1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "PreviewType"="Plane" "DisableBatching"="True" }
	LOD 0

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask B
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
			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			// Element Type Define
			#define TVE_IS_EXTRAS_ELEMENT


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

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
			uniform half _IsExtrasElement;
			uniform half _Banner;
			uniform half _Message;
			uniform half _MainValue;
			uniform half4 TVE_SeasonOptions;
			uniform half _AdditionalValue1;
			uniform half _AdditionalValue2;
			uniform half TVE_SeasonLerp;
			uniform half _AdditionalValue3;
			uniform half _AdditionalValue4;
			uniform half _ElementMode;
			uniform sampler2D _MainTex;
			uniform half4 _MainUVs;
			uniform half _MainTexMinValue;
			uniform half _MainTexMaxValue;
			uniform half _ElementIntensity;
			uniform half4 TVE_ColorsCoords;
			uniform half4 TVE_ExtrasCoords;
			uniform half4 TVE_MotionCoords;
			uniform half4 TVE_VertexCoords;
			uniform half TVE_ElementsFadeValue;
			uniform half _ElementVolumeFadeMode;
			uniform half _RaycastFadeValue;
			half GammaToLinearFloatFast( half sRGB )
			{
				return sRGB * (sRGB * (sRGB * 0.305306011h + 0.682171111h) + 0.012522878h);
			}
			
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

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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
				half Value_Main157_g18625 = _MainValue;
				half TVE_SeasonOptions_X50_g18625 = TVE_SeasonOptions.x;
				half Value_Winter158_g18625 = _AdditionalValue1;
				half Value_Spring159_g18625 = _AdditionalValue2;
				half TVE_SeasonLerp54_g18625 = TVE_SeasonLerp;
				half lerpResult168_g18625 = lerp( Value_Winter158_g18625 , Value_Spring159_g18625 , TVE_SeasonLerp54_g18625);
				half TVE_SeasonOptions_Y51_g18625 = TVE_SeasonOptions.y;
				half Value_Summer160_g18625 = _AdditionalValue3;
				half lerpResult167_g18625 = lerp( Value_Spring159_g18625 , Value_Summer160_g18625 , TVE_SeasonLerp54_g18625);
				half TVE_SeasonOptions_Z52_g18625 = TVE_SeasonOptions.z;
				half Value_Autumn161_g18625 = _AdditionalValue4;
				half lerpResult166_g18625 = lerp( Value_Summer160_g18625 , Value_Autumn161_g18625 , TVE_SeasonLerp54_g18625);
				half TVE_SeasonOptions_W53_g18625 = TVE_SeasonOptions.w;
				half lerpResult165_g18625 = lerp( Value_Autumn161_g18625 , Value_Winter158_g18625 , TVE_SeasonLerp54_g18625);
				half Element_Mode55_g18625 = _ElementMode;
				half lerpResult181_g18625 = lerp( Value_Main157_g18625 , ( ( TVE_SeasonOptions_X50_g18625 * lerpResult168_g18625 ) + ( TVE_SeasonOptions_Y51_g18625 * lerpResult167_g18625 ) + ( TVE_SeasonOptions_Z52_g18625 * lerpResult166_g18625 ) + ( TVE_SeasonOptions_W53_g18625 * lerpResult165_g18625 ) ) , Element_Mode55_g18625);
				half4 tex2DNode17_g18625 = tex2D( _MainTex, ( ( ( 1.0 - i.ase_texcoord1.xy ) * (_MainUVs).xy ) + (_MainUVs).zw ) );
				half temp_output_7_0_g20833 = _MainTexMinValue;
				half4 temp_cast_0 = (temp_output_7_0_g20833).xxxx;
				half4 break469_g18625 = saturate( ( ( tex2DNode17_g18625 - temp_cast_0 ) / ( _MainTexMaxValue - temp_output_7_0_g20833 ) ) );
				half MainTex_R73_g18625 = break469_g18625.r;
				half Base_Extras_RGB213_g18625 = ( lerpResult181_g18625 * MainTex_R73_g18625 * i.ase_color.r );
				half temp_output_9_0_g20847 = Base_Extras_RGB213_g18625;
				half sRGB8_g20847 = temp_output_9_0_g20847;
				half localGammaToLinearFloatFast8_g20847 = GammaToLinearFloatFast( sRGB8_g20847 );
				#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch1_g20847 = temp_output_9_0_g20847;
				#else
				float staticSwitch1_g20847 = localGammaToLinearFloatFast8_g20847;
				#endif
				half3 appendResult239_g18625 = (half3(0.0 , 0.0 , staticSwitch1_g20847));
				half3 Final_Overlay_RGB238_g18625 = appendResult239_g18625;
				half MainTex_A74_g18625 = break469_g18625.a;
				half4 Colors37_g20853 = TVE_ColorsCoords;
				half4 Extras37_g20853 = TVE_ExtrasCoords;
				half4 Motion37_g20853 = TVE_MotionCoords;
				half4 Vertex37_g20853 = TVE_VertexCoords;
				half4 localIS_ELEMENT37_g20853 = IS_ELEMENT( Colors37_g20853 , Extras37_g20853 , Motion37_g20853 , Vertex37_g20853 );
				half4 temp_output_35_0_g20854 = localIS_ELEMENT37_g20853;
				half temp_output_7_0_g20862 = TVE_ElementsFadeValue;
				half2 temp_cast_1 = (temp_output_7_0_g20862).xx;
				half2 temp_output_851_0_g18625 = saturate( ( ( abs( (( (temp_output_35_0_g20854).zw + ( (temp_output_35_0_g20854).xy * (WorldPosition).xz ) )*2.002 + -1.001) ) - temp_cast_1 ) / ( 1.0 - temp_output_7_0_g20862 ) ) );
				half2 break852_g18625 = ( temp_output_851_0_g18625 * temp_output_851_0_g18625 );
				half lerpResult842_g18625 = lerp( 1.0 , ( 1.0 - saturate( ( break852_g18625.x + break852_g18625.y ) ) ) , _ElementVolumeFadeMode);
				half Fade_EdgeMask656_g18625 = lerpResult842_g18625;
				half Element_Intensity56_g18625 = ( _ElementIntensity * i.ase_color.a * Fade_EdgeMask656_g18625 * _RaycastFadeValue );
				half Final_Overlay_A241_g18625 = ( MainTex_A74_g18625 * Element_Intensity56_g18625 );
				half4 appendResult474_g18625 = (half4(Final_Overlay_RGB238_g18625 , Final_Overlay_A241_g18625));
				
				
				finalColor = appendResult474_g18625;
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
Node;AmplifyShaderEditor.FunctionNode;116;-640,-1152;Inherit;False;Base Element;2;;18625;0e972c73cae2ee54ea51acc9738801d0;6,477,1,478,0,145,2,481,0,576,1,491,1;0;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;113;-640,-1408;Inherit;False;Define Element Extras;66;;20889;adca672cb6779794dba5f669b4c5f8e3;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-384,-1408;Half;False;Property;_Banner;Banner;0;0;Create;True;0;0;0;True;1;StyledBanner(Overlay Element);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-304,-1152;Half;False;True;-1;2;TVEShaderElementGUI;0;5;BOXOPHOBIC/The Vegetation Engine/Elements/Default/Extras Overlay;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;True;False;False;True;False;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;2;False;;True;0;False;;True;False;0;False;;0;False;;True;4;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;DisableBatching=True=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-256,-1408;Half;False;Property;_Message;Message;1;0;Create;True;0;0;0;True;1;StyledMessage(Info, Use the Overlay elements to control the overlay effect on vegetation or static props. Element Texture R and Particle Color R are used as value multipliers. Element Texture A and Particle Color A are used as element as alpha mask., 0,0);False;0;0;1;1;0;1;FLOAT;0
WireConnection;0;0;116;0
ASEEND*/
//CHKSM=DDDE0DF67B71FA6737C9D70DE6B5CE2322008FD3