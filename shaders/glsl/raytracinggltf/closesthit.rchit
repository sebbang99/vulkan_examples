/* Copyright (c) 2023, Sascha Willems
 *
 * SPDX-License-Identifier: MIT
 *
 */

#version 460

#extension GL_EXT_ray_tracing : require
#extension GL_GOOGLE_include_directive : require
#extension GL_EXT_nonuniform_qualifier : require
#extension GL_EXT_buffer_reference2 : require
#extension GL_EXT_scalar_block_layout : require
#extension GL_EXT_shader_explicit_arithmetic_types_int64 : require

struct RayPayload {
	vec3 color;
	float distance;
	vec3 normal;
	float reflector;
};

layout(location = 0) rayPayloadInEXT RayPayload rayPayload;
layout(location = 2) rayPayloadEXT bool shadowed;
hitAttributeEXT vec2 attribs;

layout(binding = 0, set = 0) uniform accelerationStructureEXT topLevelAS;
layout(binding = 3, set = 0) uniform sampler2D image;

struct GeometryNode {
	uint64_t vertexBufferDeviceAddress;
	uint64_t indexBufferDeviceAddress;
	int textureIndexBaseColor;
	int textureIndexOcclusion;
};
layout(binding = 4, set = 0) buffer GeometryNodes { GeometryNode nodes[]; } geometryNodes;
layout(binding = 5, set = 0) uniform sampler2D textures[];

#include "bufferreferences.glsl"
#include "geometrytypes.glsl"

void main()
{
	Triangle tri = unpackTriangle(gl_PrimitiveID, 112);
	rayPayload.color = vec3(tri.normal);

	GeometryNode geometryNode = geometryNodes.nodes[gl_GeometryIndexEXT];

	vec3 color = texture(textures[nonuniformEXT(geometryNode.textureIndexBaseColor)], tri.uv).rgb;
	if (geometryNode.textureIndexOcclusion > -1) {
		float occlusion = texture(textures[nonuniformEXT(geometryNode.textureIndexOcclusion)], tri.uv).r;
		color *= occlusion;
	}

	rayPayload.color = color;
	rayPayload.distance = gl_RayTmaxEXT;
	rayPayload.normal = normalize(tri.normal);
	rayPayload.reflector = (geometryNode.textureIndexBaseColor == 0) || (geometryNode.textureIndexBaseColor == 4) ? 1.0f : 0.0f;

	// Shadow casting
	float tmin = 0.001f;
	float tmax = 10000.0f;
	float epsilon = 0.001f;
	vec3 origin = gl_WorldRayOriginEXT + gl_WorldRayDirectionEXT * gl_HitTEXT + tri.normal * epsilon;

	shadowed = true;  
	vec3 lightVector = vec3(5.0, -12.5, 0.0);

	// Trace shadow ray and offset indices to match shadow hit/miss shader group indices
	traceRayEXT(topLevelAS, gl_RayFlagsTerminateOnFirstHitEXT | gl_RayFlagsOpaqueEXT | gl_RayFlagsSkipClosestHitShaderEXT, 0xFF, 0, 0, 1, origin, tmin, lightVector, tmax, 2);
	if (shadowed) {
		rayPayload.color *= 0.7;
	}
}
