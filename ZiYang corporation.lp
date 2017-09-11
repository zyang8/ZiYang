/* Objective function */
max: 385 X1Large +330 X1Medium +275 X1Small +385 X2Large +330 X2Medium +275 X2Small +385 X3Large +330 X3Medium +275 X3Small;

/* Constraints */
Plant1: +X1Large +X1Medium +X1Small <= 750;
Plant2: +X2Large +X2Medium +X2Small <= 900;
Plant3: +X3Large +X3Medium +X3Small <= 450;
Plant1: +20 X1Large +15 X1Medium +12 X1Small <= 13000;
Plant2: +20 X2Large +15 X2Medium +12 X2Small <= 12000;
Plant3: +20 X3Large +15 X3Medium +12 X3Small <= 5000;
Plant1: +X1Large +X2Large +X3Large <= 900;
Plant2: +X1Medium +X2Medium +X3Medium <= 1200;
Plant3: +X1Small +X2Small +X3Small <= 750;
