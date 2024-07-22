#version 460
#extension GL_EXT_ray_tracing : require

struct RayPayload {
    vec3 color;
	float distance;
	vec3 normal;
	float reflector;
};

//layout(location = 0) rayPayloadInEXT vec3 hitValue;
layout(location = 0) rayPayloadInEXT RayPayload rayPayload;

void main()
{
    //hitValue = vec3(0.0, 1.0, 0.0);
	rayPayload.color = vec3(0.1, 0.1, 0.1);

	rayPayload.distance = -1.0f;	// miss, �� skybox �ε����ٴ� ǥ��
	rayPayload.normal = vec3(0.0f);	// ��� �� ��.
	rayPayload.reflector = 0.0f;	// ��� �� ��.
}