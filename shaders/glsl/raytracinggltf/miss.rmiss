/* Copyright (c) 2023, Sascha Willems
 *
 * SPDX-License-Identifier: MIT
 *
 */

#version 460
#extension GL_EXT_ray_tracing : enable

struct RayPayload {
	vec3 color;
	float distance;
	vec3 normal;
	float reflector;
};

layout(location = 0) rayPayloadInEXT RayPayload rayPayload;

void main()
{
	rayPayload.color = vec3(0.1, 0.1, 0.1);

	rayPayload.distance = -1.0f;	// miss, 즉 skybox 부딛혔다는 표시
	rayPayload.normal = vec3(0.0f);	// 사용 안 함.
	rayPayload.reflector = 0.0f;	// 사용 안 함.
}