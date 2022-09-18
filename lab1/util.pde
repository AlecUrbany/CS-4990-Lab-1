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

float get_distance(float current_x, float current_y, float target_x, float target_y){
 float x_travel = target_x - current_x;
 float y_travel = target_y - current_y;
 float total_distance = sqrt(sq(x_travel)  + sq(y_travel));
 return total_distance;
}
