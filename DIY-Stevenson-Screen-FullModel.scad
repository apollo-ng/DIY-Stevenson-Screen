$fn=100;

phi=1.618;
pt=0.15;
thickness=2.45;

rod_d=4;
rod_l=200;

outer_d=110;
tube_d=42;

stack_n=6;
stack_h=15;

fan_w=60;
fan_h=15;
fan_d=57.5;

module fan()
{
    rotate([0,0,45])difference()
    {
        cube(size=[60,60,fan_h],center=true);

        union()
        {
            cylinder(d=57.5,h=40,center=true);
            for(x=[45:90:360])
            {
                rotate([0,0,x])translate([35.5,0,0])difference()
                {
                    cylinder(d=rod_d,h=40,center=true);
                }
            }
        }
    }
}

module support()
{
    for(x=[22.5:45:360])
    {
        rotate([0,0,x])translate([outer_d/2-10,0,2])rotate([90,0,0])linear_extrude(height = thickness, center = true, convexity = 10)
        {
            polygon( points=[[2,0],[5,0],[9,-8],[9,-15],[9,-15]] );
        }
    }
}

module reinforcement_struts(rot=[0:45:360],rtr=[35,0,pt],cs=[34,thickness,thickness])
{
    for(x=rot)
    {
        rotate([0,0,x])translate(rtr)difference()
        {
            cube(size=cs,center=true);
        }
    }
}

module spacer()
{
    translate([0,0, -(fan_h-thickness-pt)/2])for(x=[0:90:360])
    {
        rotate([0,0,x])translate([35.5,0,0])difference()
        {
            cylinder(h=fan_h,d=rod_d+thickness*2+pt,center=true);
        }
    }
}

module rodholes()
{
    for(x=[0:90:360])
    {
        rotate([0,0,x])translate([35.5,0,6])difference()
        {
            cylinder(h=60,d=rod_d+pt,center=true);
        }
    }
}

module rim()
{
    translate([0, 0, -stack_h/2+1])rotate_extrude(convexity = 10)translate([outer_d/2-thickness+0.75, 0, 0])polygon( points=[[0,-0.5],[-0.3,1.9],[-3.1,7.2],[-4,7.8],[-3.5,9],[2.45,0],[2.45,-8.2],[1.84,-9],[1.23,-9],[0,-7]] );
}

module brim(outer=outer_d,bheight=stack_h)
{
    difference()
    {
        translate([0, 0, stack_h+0.005])cylinder(h=0.2, d=outer+8,center=true);
        translate([0, 0, stack_h-2])cylinder(h=10, d=outer-6.75,center=true);
    }

    difference()
    {
        translate([0, 0, 1+stack_h/2])cylinder(h=bheight+3, d=outer+5,center=true);
        translate([0, 0, 1+stack_h/2])cylinder(h=bheight+5, d=outer+4.65,center=true);
    }
}



module shape()
{
    difference()
    {
        union()
        {
            cylinder(h=stack_h/2, d1=outer_d,d2=outer_d-thickness*3,center=true);
            translate([0, 0, -6.8])rotate_extrude(convexity = 20)translate([outer_d/2-5.6, 0, 0])circle(d=12.7);

        }
        translate([0, 0, -2.45])union()
        {
            cylinder(h=stack_h/2, d1=outer_d-thickness-1,d2=outer_d-thickness*4-0.5,center=true);
            translate([0, 0, -14.7])cylinder(d=outer_d-thickness,h=11);
            translate([0, 0, -16.7])cylinder(d=outer_d+thickness,h=11);
        }
    }

    rim();
    support();
}

module top(prod=0)
{
    difference()
    {
        union()
        {
            shape();
            spacer();
            reinforcement_struts(rot=[0:45:360],rtr=[35,0,pt],cs=[34,thickness,thickness]);

            // Air Flow Cone
            translate([0, 0, -(fan_h-thickness-pt)/2])cylinder(h=fan_h, d1=20, d2=50, center=true);
        }
        rodholes();
    }

    if (prod==1)
    {
        color("red",1)translate([0,0,-11.35])brim();
    }
}


module fan_mount(fan=0,prod=0)
{
    difference()
    {
        shape();
        union()
        {
            rodholes();
            // Center Hole
            cylinder(d=fan_d,h=30,center=true);
        }
    }

    if (fan==1)
    {
        color("red",1)translate([0,0,-6.2])fan();
    }

    if (prod==1)
    {
        color("red",1)translate([0,0,-11.35])brim();
    }
}

module tube_mount(prod=0)
{
    difference()
    {
        union()
        {
            shape();
            spacer();
        }
        rodholes();
        // Center Hole
        cylinder(d=fan_d,h=30,center=true);
    }

    translate([0,0,-(fan_h-3)/2+thickness+thickness/2])difference()
    {
        cylinder(d=tube_d+thickness*2,h=(fan_h-3),center=true);
        cylinder(d=tube_d,h=(stack_h-2)*stack_h,center=true);
    }

    difference()
    {
        union()
        {
            reinforcement_struts(rot=[45:90:360],rtr=[tube_d-thickness*2,0,thickness/2+pt/2],cs=[tube_d-thickness*6,thickness,thickness*2]);
            reinforcement_struts(rot=[0:45:360],rtr=[tube_d-thickness*2,0,thickness/2+pt/2],cs=[tube_d-thickness*6,thickness,thickness*2]);
        }
        rodholes();
    }

    if (prod==1)
    {
        color("red",1)translate([0,0,-11.35])brim();
    }
}

module fill(prod=0)
{
    difference()
    {
        union()
        {
            shape();
            spacer();
            reinforcement_struts(rot=[0:90:360],rtr=[45,0,0.5],cs=[14,thickness,thickness]);
        }
        rodholes();
        // Center Hole
        cylinder(d=54,h=30,center=true);
    }

    if (prod==1)
    {
        color("red",1)translate([0,0,-11.35])brim();
    }
}

module last(prod=0)
{
    difference()
    {
        union()
        {
            shape();
            spacer();
            reinforcement_struts(rot=[0:90:360],rtr=[tube_d-thickness*2,0,thickness/2+pt/2],cs=[tube_d-thickness*6,thickness,thickness*2]);
        }
        rodholes();
        // Center Hole
        cylinder(d=tube_d,h=(stack_h-2)*stack_h,center=true);
    }

    translate([0,0,-7/2+thickness+thickness/2])difference()
    {
        cylinder(d=tube_d+thickness*2,h=(7),center=true);
        cylinder(d=tube_d,h=(stack_h-2)*stack_h,center=true);
    }

    if (prod==1)
    {
        color("red",1)translate([0,0,-11.35])brim();
    }
}

module tube(prod=0)
{
    tube_d=tube_d-pt;
    difference()
    {
        cylinder(d=tube_d,h=((stack_n-1)*stack_h)+thickness/2,center=true);
        union()
        {
            cylinder(d=tube_d-thickness/2,h=0.05+((stack_n-1)*stack_h)+thickness/2,center=true);
            translate([0,0,(((stack_n-1)*stack_h)+thickness/2)/2-5])reinforcement_struts(rot=[0:90:360],rtr=[15,0,pt],cs=[14,thickness,10]);
            if (prod==1)
            {
                translate([0,0,-(((stack_n-1)*stack_h)-thickness/2)/2+1.375])reinforcement_struts(rot=[45:90:360],rtr=[15,0,pt],cs=[14,thickness,5]);
            }
            else
            {
                translate([0,0,-(((stack_n-1)*stack_h)-thickness/2)/2+1])reinforcement_struts(rot=[45:90:360],rtr=[15,0,pt],cs=[14,thickness,5]);
            }
        }
    }

    if (prod==1)
    {
        color("red",1)translate([0,0,-53])
        {
            difference()
            {
                translate([0, 0, stack_h+0.005])cylinder(h=0.25, d=tube_d+10,center=true);
                translate([0, 0, stack_h-2])cylinder(h=10, d=tube_d+0.15,center=true);
            }
        }
        difference()
        {
            translate([0, 0, -4.3])cylinder(h=stack_h*4.5, d=tube_d+4,center=true);
            translate([0, 0, -4.3])cylinder(h=stack_h*4.5+0.005, d=tube_d+3.65,center=true);
        }
    }
}

module bottom(prod=0)
{
    difference()
    {
        union()
        {
            rotate_extrude(convexity = 10)polygon(
                points=[[0,0],[outer_d/2-5,0],[outer_d/2-5,1],[outer_d/2-6,thickness],[0,thickness]] );

            // Air Flow Cone
            translate([0, 0, 10/2])cylinder(h=10, d1=30, d2=15, center=true);
        }

        union()
        {
            rodholes();
            translate([0, 0, 0])sensor_carrier();
        }
    }

    difference()
    {
        translate([0,0,fan_h*stack_n/1.66/2/4])cube(size=[2.5,10,fan_h*stack_n/1.66/4],center=true);
        translate([0,0,fan_h*stack_n/1.66/2])cube(size=[10,2.5,fan_h*stack_n/1.66],center=true);
    }
    translate([0,0,5])cube(size=[2.5,2.5,5],center=true);

    if (prod==1)
    {
        color("red",1)translate([0,0,15.15])rotate([0,180,0])brim(outer=outer_d-3.08,bheight=10);
    }
}

module sensor_carrier(prod=0)
{
    height=fan_h*stack_n/1.66;
    translate([0,0,height/2+thickness])cube(size=[10,2.5,height],center=true);
    //translate([0,0,height/2/4+thickness])cube(size=[2.5,8,height/4],center=true);

}

// Output selections

$difference()
{
    union()
    {
        top();

        translate([0,0,-fan_h-thickness])fan_mount(fan=1);
        translate([0,0,-fan_h*2-thickness*2])tube_mount();

        for(z=[3:1:stack_n-1])
        {
            translate([0,0,-fan_h*z-thickness*z])fill();
        }

        translate([0,0,-fan_h*stack_n-thickness*stack_n])last();
        translate([0,0,-(fan_h*2)-(((stack_n-1)*stack_h)/2)-thickness])tube();
        translate([0,0,-fan_h*(stack_n+1)-thickness*stack_n])bottom();
        translate([0,0,-fan_h*(stack_n+1)-thickness*stack_n])sensor_carrier();

    }

    translate([100,0,0])cube(size=[200,200,300],center=true);
}


bottom(prod=1);

/*
$fs = 0.1;

// ***** PARAMETERS *****

// spring measurements
wire_diameter = 2;
spring_height = 60;
spring_diameter = tube_d-1;
top_twists = 0;
full_twists = 0.3;
bottom_twists = 0;

// tuning
degrees_per_step = 20; // use multiple of (full_twists * 360)

//extraneous
height_between_turns = (spring_height - (wire_diameter*2))/full_twists; //0.115;

// ***** SPRING PARTS *****

translate([0,0,-30])union() {
    // top
    translate([0,0,spring_height-wire_diameter])
    rotate([0,0,180])
    helix(helix_dia=spring_diameter, wire_dia=wire_diameter, turn_elev=wire_diameter, degrees=360, clockwise=0, accuracy=degrees_per_step);

    // middle
    translate([0,0,wire_diameter])
    helix(spring_diameter, wire_diameter, height_between_turns, 360 * full_twists, 0, degrees_per_step);

    // bottom
    translate([0,0,0])
    helix(helix_dia=spring_diameter, wire_dia=wire_diameter, turn_elev=wire_diameter, degrees=360, clockwise=0, accuracy=degrees_per_step);
}

// ***** HELIX FUNCTION *****

module helix(helix_dia, wire_dia, turn_elev, degrees, clockwise, accuracy) {
    union() {
        for (i = [0 : (degrees / accuracy) - 1]) {
            hull() {
                translate([
                    (helix_dia/2)*sin(i*accuracy),
                    (helix_dia/2)*((2*clockwise)-1)*cos(i*accuracy),
                    (turn_elev * i*accuracy/360) + (wire_dia/2)])
                    rotate([i*accuracy,((2*clockwise)-1) * 90,0])
                    cylinder(r=wire_dia/2, h=0.01);

                    translate([
                        (helix_dia/2)*sin((i+1)*accuracy),
                        (helix_dia/2)*((2*clockwise)-1)*cos((i+1)*accuracy),
                        (turn_elev * (i+1)*accuracy/360) + (wire_dia/2)])
                        rotate([(i+1)*accuracy,((2*clockwise)-1) * 90,0])
                        cylinder(r=wire_dia/2, h=0.01);
                    }
                }
            }
        }
*/
