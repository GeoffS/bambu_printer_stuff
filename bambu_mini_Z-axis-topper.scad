include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;
perimeterWidth = 0.45;

zAxisXY = 52;
zAxisCOrnerDia = 20;
zAxisCOrnerHeight = 18;

wallXY = 2.5;
wallZ = 20;

topCZ = wallXY;

xyCtrOffset = zAxisXY/2 - zAxisCOrnerDia/2;
corner = [xyCtrOffset, xyCtrOffset, 0];

bottomOffsetZ = -zAxisCOrnerDia/2-wallZ;
frontOffsetX = (zAxisXY/2 + wallXY);
echo(str("bottomOffsetZ = ", bottomOffsetZ));

baseTopSplitZ = -zAxisCOrnerDia/2 - 4;

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

module complete()
{
    difference()
    {
        // Exterior:
        extDiaXY = zAxisCOrnerDia + 2*wallXY;
        extZ = zAxisCOrnerHeight + wallZ;
         hull() doubleY() doubleX() translate(corner+[0,0,bottomOffsetZ]) simpleChamferedCylinderDoubleEnded(d=extDiaXY, h=extZ, cz=topCZ);

        // inside:
	    hull() doubleY() doubleX() 
        {
            translate(corner) sphere(d=zAxisCOrnerDia);
            translate(corner+[0,0,40]) sphere(d=zAxisCOrnerDia);
        }

        // Hole for the extension tube:
        tubeOD = 8.2;
        tcy([frontOffsetX-tubeOD/2-topCZ, 0, -100+baseTopSplitZ+3], d=tubeOD, h=100);

        // Gap in front for the Z-axis rail:
        railSlotY = 19;
        railSlotOffsetZ = 11;;
        tcu([0, -railSlotY/2, -zAxisCOrnerDia/2], [100, railSlotY, 100]);
    }
}

module clip(d=0)
{
	tc([-200, -400-d, -200], 400);
}

if(developmentRender)
{
	// display() base();
    // displayGhost() top();

    // displayGhost() base();
    // display() top();

    display() complete();
}
else
{
	base();
}
