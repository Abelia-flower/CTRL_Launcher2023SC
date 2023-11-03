#include "../stdafx.h"
#include "Camera.h"
#include"../Components/Transform.h"
#include"../Barrages.h"

using namespace snk;

void Camera::start()
{
	ObjectBehavior::start();

	auto action = new prg::ManageActions;
	double scale = 1;
	auto shake = new prg::ManageActions;
	shake->add(new prg::FuncAction(
		[=]()mutable {
			double dir = Random<double>(0, 360_deg);
			transform->setPos(center + scale * 20 * Vec2{ Cos(dir),Sin(dir) });
			scale *= 0.6;
		}, 0.07
	));
	action->add(util::repeat(shake,6));

	action->add(new prg::FuncAction(
		[=] {transform->setPos(center); }
	));

	progress->setAction(action, U"shake");
}

const RectF Camera::getRegion()const
{
	return camera.getRegion();
}

void Camera::update(double dt)
{
	camera.update(dt);
	camera.setScale(scale);
	camera.setCenter(transform->getPos());
}

const Transformer2D Camera::getTransformer2D(bool cameraAffected)
{
	if (not cameraAffected)return Transformer2D{ Mat3x2::Identity(),TransformCursor::Yes };
	return Transformer2D(camera.createTransformer());
}
