
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

import math

def main():
    last_angle = None
    total_angle = 0
    angles = []

    print "Line [domain]\tAngle\tAngle [derivativex,right]"

    for line in open("out"):
        line = line.strip()

        if line.startswith("Speed "):
            # Skip line.
            pass
        else:
            line_number, angle = line.split(" ")
            line_number = int(line_number)
            angle = float(angle)

            if last_angle is not None:
                if angle < last_angle - 180:
                    last_angle -= 360
                elif angle > last_angle + 180:
                    last_angle += 360

                delta = angle - last_angle
                total_angle += delta
                angles.append(total_angle)


            last_angle = angle

    new_angles = []
    for i, angle in enumerate(angles):
        new_angle = 0
        count = 0
        for j in range(-20, 21):
            k = i + j
            if k >= 0 and k < len(angles):
                new_angle += angles[k]*math.exp(-(j*j)/10000)
                count += 1
            else:
                break
        else:
            # print count, new_angle, new_angle / count
            new_angles.append(new_angle)

    last_angle = None
    for i, angle in enumerate(new_angles):
        if last_angle is not None:
            print "%d %g %g" % (i, angle, angle - last_angle)
        last_angle = angle

main()
