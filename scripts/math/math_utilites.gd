class_name MathUntilites
extends Object


static func normalize_vector(vector : Vector3) -> Vector3:
	var square_length : float = sqrt(vector.length_squared())
	var inverse_length : float

	if square_length:
		inverse_length = 1 / square_length
		vector *= inverse_length

	#return [vector, square_length * inverse_length]
	return vector


static func normalize_vector_float(vector : Vector3) -> float:
	var square_length : float = sqrt(vector.length_squared())

	return square_length
