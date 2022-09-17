// Normalize an angle to be between 0 and TAU (= 2 PI)
float normalize_angle(float angle)
{
    while (angle < 0) angle += TAU;
    while (angle > TAU) angle -= TAU;
    return angle;
}

// Normalize an angle to be between -PI and PI
float normalize_angle_left_right(float angle)
{
    while (angle < -PI) angle += TAU;
    while (angle > PI) angle -= TAU;
    return angle;
}
