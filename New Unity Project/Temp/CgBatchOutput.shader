Shader "SlinDev/Planet"
{
    Properties
    {
        _MainTex("Texture (RGB)", 2D) = "black" {}
        _Color("Color", Color) = (0, 0, 0, 1)
        _AtmoColor("Atmosphere Color", Color) = (0.5, 0.5, 1.0, 1)
        _Size("Size", Float) = 0.1
        _Falloff("Falloff", Float) = 5
        _FalloffPlanet("Falloff Planet", Float) = 5
        _Transparency("Transparency", Float) = 15
        _TransparencyPlanet("Transparency Planet", Float) = 1
    }
   
	SubShader
    {
        Pass
        {
            Name "PlanetBase"
            Tags {"LightMode" = "Always"}
            Cull Back
           
            Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 9 to 9
//   d3d9 - ALU: 9 to 9
//   d3d11 - ALU: 2 to 2, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 2 to 2, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_MainTex_ST]
"!!ARBvp1.0
# 9 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
MOV result.texcoord[0].xyz, vertex.normal;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[1].z, vertex.position, c[7];
DP4 result.texcoord[1].y, vertex.position, c[6];
DP4 result.texcoord[1].x, vertex.position, c[5];
END
# 9 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_MainTex_ST]
"vs_2_0
; 9 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov oT0.xyz, v1
mad oT2.xy, v2, c8, c8.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT1.z, v0, c6
dp4 oT1.y, v0, c5
dp4 oT1.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80 // 32 used size, 6 vars
Vector 16 [_MainTex_ST] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 1 temp regs, 0 temp arrays:
// ALU 2 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedaeeinlfdilkfkbllidaocahfelfcbphkabaaaaaacmadaaaaadaaaaaa
cmaaaaaakaaaaaaaciabaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apadaaaafaepfdejfeejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefcpmabaaaaeaaaabaahpaaaaaafjaaaaaeegiocaaa
aaaaaaaaacaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaaddcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaaddccabaaaadaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafhccabaaaabaaaaaaegbcbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaal
dccabaaaadaaaaaaegbabaaaacaaaaaaegiacaaaaaaaaaaaabaaaaaaogikcaaa
aaaaaaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = normalize(_glesNormal);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp float _TransparencyPlanet;
uniform sampler2D _MainTex;
uniform highp float _FalloffPlanet;
uniform highp vec4 _Color;
uniform highp vec4 _AtmoColor;
void main ()
{
  highp vec4 color_1;
  highp vec4 atmo_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize(xlv_TEXCOORD0);
  atmo_2.xyz = _AtmoColor.xyz;
  atmo_2.w = pow ((1.00000 - clamp (dot (normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1)), tmpvar_3), 0.00000, 1.00000)), _FalloffPlanet);
  atmo_2.w = (atmo_2.w * (_TransparencyPlanet * _Color).x);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD2);
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  color_1.w = tmpvar_5.w;
  color_1.xyz = mix (tmpvar_5.xyz, _AtmoColor.xyz, atmo_2.www);
  gl_FragData[0] = (color_1 * dot (normalize((xlv_TEXCOORD1 - _WorldSpaceLightPos0.xyz)), tmpvar_3));
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = normalize(_glesNormal);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp float _TransparencyPlanet;
uniform sampler2D _MainTex;
uniform highp float _FalloffPlanet;
uniform highp vec4 _Color;
uniform highp vec4 _AtmoColor;
void main ()
{
  highp vec4 color_1;
  highp vec4 atmo_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize(xlv_TEXCOORD0);
  atmo_2.xyz = _AtmoColor.xyz;
  atmo_2.w = pow ((1.00000 - clamp (dot (normalize((_WorldSpaceCameraPos - xlv_TEXCOORD1)), tmpvar_3), 0.00000, 1.00000)), _FalloffPlanet);
  atmo_2.w = (atmo_2.w * (_TransparencyPlanet * _Color).x);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD2);
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  color_1.w = tmpvar_5.w;
  color_1.xyz = mix (tmpvar_5.xyz, _AtmoColor.xyz, atmo_2.www);
  gl_FragData[0] = (color_1 * dot (normalize((xlv_TEXCOORD1 - _WorldSpaceLightPos0.xyz)), tmpvar_3));
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_MainTex_ST]
"agal_vs
[bc]
aaaaaaaaaaaaahaeabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v0.xyz, a1
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaiaaaaoeabaaaaaa mul r0.xy, a3, c8
abaaaaaaacaaadaeaaaaaafeacaaaaaaaiaaaaooabaaaaaa add v2.xy, r0.xyyy, c8.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaabaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v1.z, a0, c6
bdaaaaaaabaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v1.y, a0, c5
bdaaaaaaabaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v1.x, a0, c4
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80 // 32 used size, 6 vars
Vector 16 [_MainTex_ST] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 1 temp regs, 0 temp arrays:
// ALU 2 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefieceddgofelcgffiifoolackjcacanhdemcgpabaaaaaaiiaeaaaaaeaaaaaa
daaaaaaaiiabaaaaimadaaaaaaaeaaaaebgpgodjfaabaaaafaabaaaaaaacpopp
aeabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaabaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaaeaaagaaaaaaaaaa
aaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
bpaaaaacafaaaciaacaaapjaafaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaae
aaaaahiaagaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkja
aaaaoeiaaeaaaaaeabaaahoaajaaoekaaaaappjaaaaaoeiaaeaaaaaeacaaadoa
acaaoejaabaaoekaabaaookaafaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaae
aaaaapiaacaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacaaaaahoa
abaaoejappppaaaafdeieefcpmabaaaaeaaaabaahpaaaaaafjaaaaaeegiocaaa
aaaaaaaaacaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaaddcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaaddccabaaaadaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafhccabaaaabaaaaaaegbcbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaal
dccabaaaadaaaaaaegbabaaaacaaaaaaegiacaaaaaaaaaaaabaaaaaaogikcaaa
aaaaaaaaabaaaaaadoaaaaabejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apadaaaafaepfdejfeejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 23 to 23, TEX: 1 to 1
//   d3d9 - ALU: 26 to 26, TEX: 1 to 1
//   d3d11 - ALU: 21 to 21, TEX: 1 to 1, FLOW: 1 to 1
//   d3d11_9x - ALU: 21 to 21, TEX: 1 to 1, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_AtmoColor]
Float 4 [_FalloffPlanet]
Float 5 [_TransparencyPlanet]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_fog_exp2;
OPTION ARB_precision_hint_fastest;
# 23 ALU, 1 TEX
PARAM c[7] = { program.local[0..5],
		{ 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[2], texture[0], 2D;
ADD R2.xyz, -fragment.texcoord[1], c[0];
DP3 R1.x, R2, R2;
RSQ R1.w, R1.x;
DP3 R1.y, fragment.texcoord[0], fragment.texcoord[0];
RSQ R1.y, R1.y;
MUL R2.xyz, R1.w, R2;
MUL R1.xyz, R1.y, fragment.texcoord[0];
DP3_SAT R1.w, R2, R1;
ADD R2.x, -R1.w, c[6];
MOV R1.w, c[2].x;
MUL R0, R0, c[2];
POW R2.x, R2.x, c[4].x;
MUL R1.w, R1, c[5].x;
ADD R3.xyz, fragment.texcoord[1], -c[1];
MUL R1.w, R2.x, R1;
DP3 R2.x, R3, R3;
RSQ R2.w, R2.x;
ADD R2.xyz, -R0, c[3];
MUL R3.xyz, R2.w, R3;
MAD R0.xyz, R1.w, R2, R0;
DP3 R1.x, R1, R3;
MUL result.color, R0, R1.x;
END
# 23 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_AtmoColor]
Float 4 [_FalloffPlanet]
Float 5 [_TransparencyPlanet]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 26 ALU, 1 TEX
dcl_2d s0
def c6, 1.00000000, 0, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xy
texld r2, t2, s0
add r4.xyz, -t1, c0
dp3 r0.x, r4, r4
dp3 r1.x, t0, t0
rsq r1.x, r1.x
rsq r0.x, r0.x
mul r0.xyz, r0.x, r4
mul r3.xyz, r1.x, t0
dp3_sat r0.x, r0, r3
add r0.x, -r0, c6
pow r1.w, r0.x, c4.x
mov r0.x, c5
mul r2, r2, c2
mul r0.x, c2, r0
mul r0.x, r1.w, r0
add r4.xyz, t1, -c1
dp3 r1.x, r4, r4
rsq r1.x, r1.x
add r5.xyz, -r2, c3
mul r1.xyz, r1.x, r4
mad r0.xyz, r0.x, r5, r2
dp3 r1.x, r3, r1
mov r0.w, r2
mul r0, r0, r1.x
mov oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 80 // 72 used size, 6 vars
Vector 32 [_Color] 4
Vector 48 [_AtmoColor] 4
Float 64 [_FalloffPlanet]
Float 68 [_TransparencyPlanet]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
SetTexture 0 [_MainTex] 2D 0
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcchicblghdacfodkbankamnnpdhniledabaaaaaaeaaeaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcfaadaaaaeaaaaaaaneaaaaaafjaaaaaeegiocaaa
aaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaa
egbcbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaabaaaaaabacaaaahbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaibcaabaaaaaaaaaaa
akaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpcpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaj
ccaabaaaaaaaaaaaakiacaaaaaaaaaaaacaaaaaabkiacaaaaaaaaaaaaeaaaaaa
diaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
dcaaaaamocaabaaaaaaaaaaaagajbaiaebaaaaaaacaaaaaaagijcaaaaaaaaaaa
acaaaaaaagijcaaaaaaaaaaaadaaaaaadiaaaaaipcaabaaaacaaaaaaegaobaaa
acaaaaaaegiocaaaaaaaaaaaacaaaaaadcaaaaajhcaabaaaacaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaiaebaaaaaaacaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaahpccabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_AtmoColor]
Float 4 [_FalloffPlanet]
Float 5 [_TransparencyPlanet]
SetTexture 0 [_MainTex] 2D
"agal_ps
c6 1.0 0.0 0.0 0.0
[bc]
ciaaaaaaacaaapacacaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v2, s0 <2d wrap linear point>
bfaaaaaaaeaaahacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, v1
abaaaaaaaeaaahacaeaaaakeacaaaaaaaaaaaaoeabaaaaaa add r4.xyz, r4.xyzz, c0
bcaaaaaaaaaaabacaeaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r0.x, r4.xyzz, r4.xyzz
bcaaaaaaabaaabacaaaaaaoeaeaaaaaaaaaaaaoeaeaaaaaa dp3 r1.x, v0, v0
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r0.xyz, r0.x, r4.xyzz
adaaaaaaadaaahacabaaaaaaacaaaaaaaaaaaaoeaeaaaaaa mul r3.xyz, r1.x, v0
bcaaaaaaaaaaabacaaaaaakeacaaaaaaadaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r3.xyzz
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaoeabaaaaaa add r0.x, r0.x, c6
alaaaaaaabaaapacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa pow r1, r0.x, c4.x
aaaaaaaaaaaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c5
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeabaaaaaa mul r2, r2, c2
adaaaaaaaaaaabacacaaaaoeabaaaaaaaaaaaaaaacaaaaaa mul r0.x, c2, r0.x
adaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r1.x, r0.x
acaaaaaaaeaaahacabaaaaoeaeaaaaaaabaaaaoeabaaaaaa sub r4.xyz, v1, c1
bcaaaaaaabaaabacaeaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r1.x, r4.xyzz, r4.xyzz
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
bfaaaaaaafaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r2.xyzz
abaaaaaaafaaahacafaaaakeacaaaaaaadaaaaoeabaaaaaa add r5.xyz, r5.xyzz, c3
adaaaaaaabaaahacabaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r1.xyz, r1.x, r4.xyzz
adaaaaaaaaaaahacaaaaaaaaacaaaaaaafaaaakeacaaaaaa mul r0.xyz, r0.x, r5.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
bcaaaaaaabaaabacadaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r1.x, r3.xyzz, r1.xyzz
aaaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaaaacaaaaaa mul r0, r0, r1.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 80 // 72 used size, 6 vars
Vector 32 [_Color] 4
Vector 48 [_AtmoColor] 4
Float 64 [_FalloffPlanet]
Float 68 [_TransparencyPlanet]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
SetTexture 0 [_MainTex] 2D 0
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedncfmmknbpdbdbdgphmkgkegnfnjcnennabaaaaaapmafaaaaaeaaaaaa
daaaaaaaoiabaaaaeaafaaaamiafaaaaebgpgodjlaabaaaalaabaaaaaaacpppp
geabaaaaemaaaaaaadaaciaaaaaaemaaaaaaemaaabaaceaaaaaaemaaaaaaaaaa
aaaaacaaadaaaaaaaaaaaaaaabaaaeaaabaaadaaaaaaaaaaacaaaaaaabaaaeaa
aaaaaaaaabacppppfbaaaaafafaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
bpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaaahlabpaaaaacaaaaaaia
acaaadlabpaaaaacaaaaaajaaaaiapkaacaaaaadaaaaahiaabaaoelbadaaoeka
ceaaaaacabaaahiaaaaaoeiaceaaaaacaaaaahiaaaaaoelaaiaaaaadaaaabiia
abaaoeiaaaaaoeiaacaaaaadaaaaaiiaaaaappibafaaaakacaaaaaadabaaabia
aaaappiaacaaaakaabaaaaacacaaahiaaaaaoekaafaaaaadaaaaaiiaacaaaaia
acaaffkaafaaaaadaaaaaiiaaaaappiaabaaaaiaecaaaaadabaaapiaacaaoela
aaaioekaaeaaaaaeacaaahiaabaaoeiaacaaoeibabaaoekaafaaaaadabaaapia
abaaoeiaaaaaoekaaeaaaaaeabaaahiaaaaappiaacaaoeiaabaaoeiaacaaaaad
acaaahiaabaaoelaaeaaoekbceaaaaacadaaahiaacaaoeiaaiaaaaadaaaaabia
adaaoeiaaaaaoeiaafaaaaadaaaaapiaaaaaaaiaabaaoeiaabaaaaacaaaiapia
aaaaoeiappppaaaafdeieefcfaadaaaaeaaaaaaaneaaaaaafjaaaaaeegiocaaa
aaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaaaeaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaa
egbcbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaabaaaaaabacaaaahbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaibcaabaaaaaaaaaaa
akaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpcpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaj
ccaabaaaaaaaaaaaakiacaaaaaaaaaaaacaaaaaabkiacaaaaaaaaaaaaeaaaaaa
diaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
dcaaaaamocaabaaaaaaaaaaaagajbaiaebaaaaaaacaaaaaaagijcaaaaaaaaaaa
acaaaaaaagijcaaaaaaaaaaaadaaaaaadiaaaaaipcaabaaaacaaaaaaegaobaaa
acaaaaaaegiocaaaaaaaaaaaacaaaaaadcaaaaajhcaabaaaacaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaiaebaaaaaaacaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaahpccabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaadoaaaaab
ejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

}

#LINE 73

        }
   
        Pass
        {
            Name "AtmosphereBase"
            Tags {"LightMode" = "Always"}
            Cull Front
            Blend SrcAlpha One
           
            Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 11 to 11
//   d3d9 - ALU: 11 to 11
//   d3d11 - ALU: 2 to 2, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 2 to 2, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Float 9 [_Size]
"!!ARBvp1.0
# 11 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].x;
MOV R0.w, vertex.position;
ADD R0.xyz, R0, vertex.position;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
DP4 result.texcoord[1].z, R0, c[7];
DP4 result.texcoord[1].y, R0, c[6];
DP4 result.texcoord[1].x, R0, c[5];
MOV result.texcoord[0].xyz, vertex.normal;
END
# 11 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Float 8 [_Size]
"vs_2_0
; 11 ALU
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c8.x
mov r0.w, v0
add r0.xyz, r0, v0
dp4 oPos.w, r0, c3
dp4 oPos.z, r0, c2
dp4 oPos.y, r0, c1
dp4 oPos.x, r0, c0
dp4 oT1.z, r0, c6
dp4 oT1.y, r0, c5
dp4 oT1.x, r0, c4
mov oT0.xyz, v1
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
ConstBuffer "$Globals" 64 // 52 used size, 6 vars
Float 48 [_Size]
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 2 temp regs, 0 temp arrays:
// ALU 2 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlgdpaifbmkemlfimacjlhhkgjahhdkigabaaaaaapiacaaaaadaaaaaa
cmaaaaaakaaaaaaabaabaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaafaepfdejfeejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcoaabaaaaeaaaabaahiaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
giaaaaacacaaaaaadcaaaaakhcaabaaaaaaaaaaaegbcbaaaabaaaaaaagiacaaa
aaaaaaaaadaaaaaaegbcbaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
abaaaaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaabaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaabaaaaaadgaaaaafhccabaaaabaaaaaaegbcbaaaabaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaabaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaabaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;

uniform highp float _Size;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2.w = _glesVertex.w;
  tmpvar_2.xyz = (_glesVertex.xyz + (tmpvar_1 * _Size));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_2);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (_Object2World * tmpvar_2).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp float _Transparency;
uniform highp float _Falloff;
uniform highp vec4 _Color;
uniform highp vec4 _AtmoColor;
void main ()
{
  highp vec4 color_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize(xlv_TEXCOORD0);
  color_1.xyz = _AtmoColor.xyz;
  color_1.w = pow (clamp (dot (normalize((xlv_TEXCOORD1 - _WorldSpaceCameraPos)), tmpvar_2), 0.00000, 1.00000), _Falloff);
  color_1.w = (color_1.w * ((_Transparency * _Color) * dot (normalize((xlv_TEXCOORD1 - _WorldSpaceLightPos0.xyz)), tmpvar_2)).x);
  gl_FragData[0] = color_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;

uniform highp float _Size;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2.w = _glesVertex.w;
  tmpvar_2.xyz = (_glesVertex.xyz + (tmpvar_1 * _Size));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_2);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (_Object2World * tmpvar_2).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp float _Transparency;
uniform highp float _Falloff;
uniform highp vec4 _Color;
uniform highp vec4 _AtmoColor;
void main ()
{
  highp vec4 color_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize(xlv_TEXCOORD0);
  color_1.xyz = _AtmoColor.xyz;
  color_1.w = pow (clamp (dot (normalize((xlv_TEXCOORD1 - _WorldSpaceCameraPos)), tmpvar_2), 0.00000, 1.00000), _Falloff);
  color_1.w = (color_1.w * ((_Transparency * _Color) * dot (normalize((xlv_TEXCOORD1 - _WorldSpaceLightPos0.xyz)), tmpvar_2)).x);
  gl_FragData[0] = color_1;
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Float 8 [_Size]
"agal_vs
[bc]
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaiaaaaaaabaaaaaa mul r0.xyz, a1, c8.x
aaaaaaaaaaaaaiacaaaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.w, a0
abaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaoeaaaaaaaa add r0.xyz, r0.xyzz, a0
bdaaaaaaaaaaaiadaaaaaaoeacaaaaaaadaaaaoeabaaaaaa dp4 o0.w, r0, c3
bdaaaaaaaaaaaeadaaaaaaoeacaaaaaaacaaaaoeabaaaaaa dp4 o0.z, r0, c2
bdaaaaaaaaaaacadaaaaaaoeacaaaaaaabaaaaoeabaaaaaa dp4 o0.y, r0, c1
bdaaaaaaaaaaabadaaaaaaoeacaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, r0, c0
bdaaaaaaabaaaeaeaaaaaaoeacaaaaaaagaaaaoeabaaaaaa dp4 v1.z, r0, c6
bdaaaaaaabaaacaeaaaaaaoeacaaaaaaafaaaaoeabaaaaaa dp4 v1.y, r0, c5
bdaaaaaaabaaabaeaaaaaaoeacaaaaaaaeaaaaoeabaaaaaa dp4 v1.x, r0, c4
aaaaaaaaaaaaahaeabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v0.xyz, a1
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
ConstBuffer "$Globals" 64 // 52 used size, 6 vars
Float 48 [_Size]
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 2 temp regs, 0 temp arrays:
// ALU 2 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedoifdbfojgpfjpnpjkjcblegeogelnomgabaaaaaafeaeaaaaaeaaaaaa
daaaaaaaiiabaaaahaadaaaaoeadaaaaebgpgodjfaabaaaafaabaaaaaaacpopp
aeabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaadaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaaeaaagaaaaaaaaaa
aaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
abaaaaacaaaaahiaaaaaoejaaeaaaaaeaaaaahiaabaaoejaabaaaakaaaaaoeia
afaaaaadabaaahiaaaaaffiaahaaoekaaeaaaaaeabaaahiaagaaoekaaaaaaaia
abaaoeiaaeaaaaaeabaaahiaaiaaoekaaaaakkiaabaaoeiaaeaaaaaeabaaahoa
ajaaoekaaaaappjaabaaoeiaafaaaaadabaaapiaaaaaffiaadaaoekaaeaaaaae
abaaapiaacaaoekaaaaaaaiaabaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkia
abaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacaaaaahoa
abaaoejappppaaaafdeieefcoaabaaaaeaaaabaahiaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagiaaaaacacaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegbcbaaaabaaaaaaagiacaaaaaaaaaaaadaaaaaa
egbcbaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaabaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
abaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaabaaaaaa
dgaaaaafhccabaaaabaaaaaaegbcbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaabaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheogmaaaaaaadaaaaaaaiaaaaaa
faaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
acaaaaaaapaaaaaafaepfdejfeejepeoaaeoepfcenebemaafeeffiedepepfcee
aaklklklepfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 19 to 19, TEX: 0 to 0
//   d3d9 - ALU: 22 to 22
//   d3d11 - ALU: 19 to 19, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 19 to 19, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_AtmoColor]
Float 4 [_Falloff]
Float 5 [_Transparency]
"!!ARBfp1.0
OPTION ARB_fog_exp2;
OPTION ARB_precision_hint_fastest;
# 19 ALU, 0 TEX
PARAM c[6] = { program.local[0..5] };
TEMP R0;
TEMP R1;
TEMP R2;
ADD R0.xyz, fragment.texcoord[1], -c[0];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ADD R2.xyz, fragment.texcoord[1], -c[1];
DP3 R0.w, R2, R2;
DP3 R0.x, fragment.texcoord[0], fragment.texcoord[0];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[0];
RSQ R1.w, R0.w;
DP3_SAT R0.w, R1, R0;
MUL R1.xyz, R1.w, R2;
DP3 R0.y, R0, R1;
MOV R1.w, c[2].x;
MUL R0.x, R1.w, c[5];
MUL R0.y, R0.x, R0;
POW R0.x, R0.w, c[4].x;
MUL result.color.w, R0.x, R0.y;
MOV result.color.xyz, c[3];
END
# 19 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_AtmoColor]
Float 4 [_Falloff]
Float 5 [_Transparency]
"ps_2_0
; 22 ALU
dcl t0.xyz
dcl t1.xyz
add r0.xyz, t1, -c0
dp3 r2.x, r0, r0
rsq r2.x, r2.x
mul r0.xyz, r2.x, r0
dp3 r1.x, t0, t0
rsq r1.x, r1.x
mul r1.xyz, r1.x, t0
dp3_sat r0.x, r0, r1
pow r3.x, r0.x, c4.x
add r2.xyz, t1, -c1
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul r0.xyz, r0.x, r2
dp3 r0.x, r1, r0
mov r2.x, c5
mul r1.x, c2, r2
mul r0.x, r1, r0
mov r1.xyz, c3
mul r1.w, r3.x, r0.x
mov oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 64 // 60 used size, 6 vars
Vector 16 [_Color] 4
Vector 32 [_AtmoColor] 4
Float 52 [_Falloff]
Float 56 [_Transparency]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
// 21 instructions, 2 temp regs, 0 temp arrays:
// ALU 19 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedaaoplaafhiceaefdinnbclmdjijdeoijabaaaaaagaadaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefciiacaaaaeaaaaaaakcaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaagcbaaaadhcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaa
egbcbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaabaaaaaabacaaaahbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaabkiacaaa
aaaaaaaaadaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaj
ocaabaaaaaaaaaaaagbjbaaaacaaaaaaagijcaiaebaaaaaaacaaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaajgahbaaaaaaaaaaajgahbaaaaaaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaa
aaaaaaaapgapbaaaabaaaaaabaaaaaahccaabaaaaaaaaaaajgahbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaajecaabaaaaaaaaaaaakiacaaaaaaaaaaaabaaaaaa
ckiacaaaaaaaaaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
ckaabaaaaaaaaaaadiaaaaahiccabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadgaaaaaghccabaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_AtmoColor]
Float 4 [_Falloff]
Float 5 [_Transparency]
"agal_ps
[bc]
acaaaaaaaaaaahacabaaaaoeaeaaaaaaaaaaaaoeabaaaaaa sub r0.xyz, v1, c0
bcaaaaaaacaaabacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r2.x, r0.xyzz, r0.xyzz
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
adaaaaaaaaaaahacacaaaaaaacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r2.x, r0.xyzz
bcaaaaaaabaaabacaaaaaaoeaeaaaaaaaaaaaaoeaeaaaaaa dp3 r1.x, v0, v0
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaaaaaaaoeaeaaaaaa mul r1.xyz, r1.x, v0
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaadaaapacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa pow r3, r0.x, c4.x
acaaaaaaacaaahacabaaaaoeaeaaaaaaabaaaaoeabaaaaaa sub r2.xyz, v1, c1
bcaaaaaaaaaaabacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.x, r2.xyzz, r2.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
bcaaaaaaaaaaabacabaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r0.xyzz
aaaaaaaaacaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c5
adaaaaaaabaaabacacaaaaoeabaaaaaaacaaaaaaacaaaaaa mul r1.x, c2, r2.x
adaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r1.x, r0.x
aaaaaaaaabaaahacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c3
adaaaaaaabaaaiacadaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r1.w, r3.x, r0.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 64 // 60 used size, 6 vars
Vector 16 [_Color] 4
Vector 32 [_AtmoColor] 4
Float 52 [_Falloff]
Float 56 [_Transparency]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
// 21 instructions, 2 temp regs, 0 temp arrays:
// ALU 19 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedbkplfbanpbhechbfgneaogedaikfddegabaaaaaajmaeaaaaaeaaaaaa
daaaaaaagiabaaaapiadaaaagiaeaaaaebgpgodjdaabaaaadaabaaaaaaacpppp
oiaaaaaaeiaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaaaaaeiaaaaaaabaa
adaaaaaaaaaaaaaaabaaaeaaabaaadaaaaaaaaaaacaaaaaaabaaaeaaaaaaaaaa
abacppppbpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaaahlaacaaaaad
aaaaahiaabaaoelaaeaaoekbceaaaaacabaaahiaaaaaoeiaceaaaaacaaaaahia
aaaaoelaaiaaaaadaaaaaiiaabaaoeiaaaaaoeiaabaaaaacabaaaeiaacaakkka
afaaaaadabaaabiaabaakkiaaaaaaakaafaaaaadaaaaaiiaaaaappiaabaaaaia
acaaaaadabaaahiaabaaoelaadaaoekbceaaaaacacaaahiaabaaoeiaaiaaaaad
aaaabbiaacaaoeiaaaaaoeiacaaaaaadabaaabiaaaaaaaiaacaaffkaafaaaaad
aaaaaiiaaaaappiaabaaaaiaabaaaaacaaaaahiaabaaoekaabaaaaacaaaiapia
aaaaoeiappppaaaafdeieefciiacaaaaeaaaaaaakcaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaaabaaaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabacaaaahbcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaabkiacaaaaaaaaaaaadaaaaaa
bjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajocaabaaaaaaaaaaa
agbjbaaaacaaaaaaagijcaiaebaaaaaaacaaaaaaaaaaaaaabaaaaaahicaabaaa
abaaaaaajgahbaaaaaaaaaaajgahbaaaaaaaaaaaeeaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaapgapbaaa
abaaaaaabaaaaaahccaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaajecaabaaaaaaaaaaaakiacaaaaaaaaaaaabaaaaaackiacaaaaaaaaaaa
adaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaackaabaaaaaaaaaaa
diaaaaahiccabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadgaaaaag
hccabaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaadoaaaaabejfdeheogiaaaaaa
adaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaafmaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

}

#LINE 127

        }
    }
   
    FallBack "Diffuse"
}