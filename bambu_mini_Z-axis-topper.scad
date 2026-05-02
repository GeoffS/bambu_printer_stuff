include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

zAxisXY = 51;
zAxisCOrnerDia = 20;
zAxisCOrnerHeight = 18;

wallXYZ = 2.5;

xyCtrOffset = zAxisXY/2 - zAxisCOrnerDia/2;
corner = [xyCtrOffset, xyCtrOffset, 0];

bottomOffsetZ = -zAxisCOrnerDia/2-wallXYZ;
echo(str("bottomOffsetZ = ", bottomOffsetZ));

module itemModule()
{
    difference()
    {
        // Exterior:
        extDiaXY = zAxisCOrnerDia + 2*wallXYZ;
        extZ = zAxisCOrnerHeight + wallXYZ;
         hull() doubleY() doubleX() translate(corner+[0,0,bottomOffsetZ]) simpleChamferedCylinderDoubleEnded(d=extDiaXY, h=extZ, cz=wallXYZ);

        // inside:
	    hull() doubleY() doubleX() 
        {
            translate(corner) sphere(d=zAxisCOrnerDia);
            translate(corner+[0,0,40]) sphere(d=zAxisCOrnerDia);
        }

        // Gap in front for the Z-axis rail:
        railSlotY = 19;
        railSlotOffsetZ = 11;;
        tcu([0, -railSlotY/2, bottomOffsetZ+railSlotOffsetZ], [100, railSlotY, 100]);
    }
}

module clip(d=0)
{
	// tc([-200, -400-d, -200], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
