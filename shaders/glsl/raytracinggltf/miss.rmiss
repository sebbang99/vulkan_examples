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

	rayPayload.distance = -1.0f;	// miss, �� skybox �ε����ٴ� ǥ��
	rayPayload.normal = vec3(0.0f);	// ��� �� ��.
	rayPayload.reflector = 0.0f;	// ��� �� ��.
}