#pragma once
#include<Siv3D.hpp>

double squared(double x);		//xの二乗を返す

double Distance(Vec2 a, Vec2 b);	//二つの座標点の距離を返す

Vec2 Rotation(Vec2 a, double theta);//ベクトルaをtheta回転させたベクトルを返す

double InnerProduct(Vec2 a, Vec2 b);//二つのベクトルの内積を返す

double AbsV(Vec2 a);				//ベクトルの大きさを返す

double InteriorAngle(Vec2 a, Vec2 b);//二つのベクトルの内角を返す

Vec2 Merikomi(Circle pac, Vec2 velocity,Vec2 point);//めり込みを直した後のパックの座標を返す

Vec2 Merikomi(Circle pac, Circle mallet, Vec2 velocity);//パックとマレットがめり込む場合、パックの座標を戻す

Line MakeLine(double len, double dir, Vec2 start);//始点と方向と長さで線分を生成

double CalDir(Vec2 start, Vec2 end);//終点と始点をもらい、dirを計算する
