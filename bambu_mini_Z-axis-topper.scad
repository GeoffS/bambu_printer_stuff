include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;
perimeterWidth = 0.45;

makeTop = false;
makeBase = false;
makeTopper = false;

zAxisXY = 50.5;
zAxisCOrnerDia = 18;
zAxisCOrnerHeight = 18 + 6;

wallXY = 2.5;

tubeOD = 8.2;

topCZ = wallXY;

xyCtrOffset = zAxisXY/2 - zAxisCOrnerDia/2;
corner = [xyCtrOffset, xyCtrOffset, 0];

frontOffsetX = (zAxisXY/2 + wallXY);

baseTopSplitZ = -zAxisCOrnerDia/2 - 4;

$fn = 180;

module base()
{
    difference()
    {
        complete();
        tcu([-200, -200, -400+baseTopSplitZ], 400);
    }
}

module top()
{
    difference()
    {
        complete();
        tcu([-200, -200, baseTopSplitZ], 400);
    }
}

module topper()
{
    topperDia = 25;
    difference() 
    {
        sphere(d=topperDia);

        // Flatten bottom:
        tcu([-200, -200, -400-topperDia/2*0.707], 400);

        // Hole for the extension tube:
        tcy([0,0,-100+topperDia/2*0.7], d=tubeOD, h=100);
    }  
}

module complete()
{
    difference()
    {
        // Exterior:
        hull() 
        {
            // MAGIC!!!
            //  Make the angle betweeen the center cylinder and the edges 45 degress.
            //  -----------------------------------------vvvv
            doubleY() topCylinder(xSign= 1, yMult=0,topZ=24.2);
            doubleY() topCylinder(xSign= 1, yMult=1, topZ=8);
            doubleY() topCylinder(xSign=-1, yMult=1, topZ=8);
        }

        // inside:
	    hull() doubleY() doubleX() 
        {
            translate(corner) sphere(d=zAxisCOrnerDia);
            translate(corner+[0,0,40]) sphere(d=zAxisCOrnerDia);
        }

        // Hole for the extension tube:
        tcy([frontOffsetX-tubeOD/2-topCZ, 0, -100+baseTopSplitZ+3], d=tubeOD, h=100);

        // Gap in front for the Z-axis rail:
        railSlotY = 19;
        railSlotOffsetZ = 11;;
        tcu([0, -railSlotY/2, -zAxisCOrnerDia/2+10], [100, railSlotY, 100]);

        // Locator screw hole at rear:
        translate([-44/2, 0, baseTopSplitZ])
        {
            tcy([0,0,-20+4], d=3, h=20);
            tcy([0,0,-20], d=3.4, h=20);
            tcy([0,0,-20-2.3], d=6, h=20);
        }

        // Double sided tape recess:
        tapeRecessX = 30;
        tapeRecessY = 20; // 3/4" + a bit
        tapeRecessZ = 0.9;
        tcu([-tapeRecessX/2, -tapeRecessY/2, -zAxisCOrnerDia/2-tapeRecessZ], [tapeRecessX, tapeRecessY, 20]);

        // // Print only half for fit Checking:
        // tcu([-200, -400, -200], 400);
    }
}

module topCylinder(xSign, yMult, topZ)
{
    bottomOffsetZ = -zAxisCOrnerDia/2 - topZ;
    extDiaXY = zAxisCOrnerDia + 2*wallXY;
    extZ = zAxisCOrnerHeight + topZ;
    echo(str("topCylinder() extZ = ", extZ));

    translate([corner.x*xSign, corner.y*yMult, corner.z+bottomOffsetZ]) simpleChamferedCylinderDoubleEnded(d=extDiaXY, h=extZ, cz=topCZ);
}

module clip(d=0)
{
	// tc([-200, -400-d, -200], 400);
}

if(developmentRender)
{
	// display() base();
    // displayGhost() top();

    // displayGhost() base();
    display() top();

    // display() translate([0,0,0.2]) base();
    // display() top();

    // display() topper();
    // translate([-60,0,0])
    // {
    //     displayGhost() base();
    //     displayGhost() top();
    // }

    // display() complete();
}
else
{
	if(makeBase) base();
	if(makeTop) rotate([180,0,0]) top();
	if(makeTopper) topper();
}
