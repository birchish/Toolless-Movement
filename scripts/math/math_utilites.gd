class_name MathUntilites
extends Object


# Similar to a a Valve vector nomralize
# https://github.com/ValveSoftware/source-sdk-2013/blob/39f6dde8fbc238727c020d13b05ecadd31bda4c0/src/public/mathlib/vector.h#L2255C1-L2255C47
static func normalize_vector(vector : Vector3) -> Vector3:
	var square_length : float = sqrt(vector.length_squared())

	if square_length:
		vector /= square_length

	#return [vector, square_length * inverse_length]
	return vector


static func normalize_vector_float(vector : Vector3) -> float:
	var square_length : float = sqrt(vector.length_squared())

	return square_length
