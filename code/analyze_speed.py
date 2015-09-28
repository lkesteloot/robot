
# The input must be a sequence of lines, either:
#
#    speed X
#
# where X is the speed of the motor, between -255 and 255, or:
#
#    Y Z
#
# where Y is the line number and Z is the angle of the motor.
#
# The program doesn't deal well with partial lines. Clean up the text file first.

def main():
    speed = None
    last_speed = None
    last_angle = None
    total_angle = 0
    total_lines = 0
    # Each series is map from pwm to speed.
    series_list = []

    for line in open("out"):
        line = line.strip()

        if line.startswith("Speed "):
            if total_lines > 0 and series_list:
                series = series_list[-1]
                series[speed] = float(total_angle) / total_lines

            speed = int(line[6:])
            if last_speed is None or abs(speed - last_speed) > 100:
                series_list.append({})

            last_speed = speed
            last_angle = None
            total_angle = 0
            total_lines = 0
        else:
            line_number, angle = line.split(" ")
            line_number = int(line_number)
            angle = float(angle)

            if speed is not None:
                if last_angle is not None:
                    if angle < last_angle - 180:
                        last_angle -= 360
                    elif angle > last_angle + 180:
                        last_angle += 360

                    delta = angle - last_angle
                    if line_number > 50:
                        total_angle += delta
                        total_lines += 1

                last_angle = angle

    if total_lines > 0 and series_list:
        series = series_list[-1]
        series[speed] = float(total_angle) / total_lines

    print "PWM [domain]\t" + "\t".join("Speed %d" % (i + 1) for i in range(len(series_list)))

    speeds = set()
    for series in series_list:
        speeds.update(series.keys())
    speeds = sorted(list(speeds))
    for speed in speeds:
        print "%d %s" % (speed, " ".join("%g" % series.get(speed, 0) for series in series_list))

main()
