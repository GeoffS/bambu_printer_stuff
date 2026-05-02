include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

zAxisXY = 50;
zAxisCOrnerDia = 20;
zAxisCOrnerHeight = 20;

xyCtrOffset = zAxisXY/2 - zAxisCOrnerDia/2;
corner = [xyCtrOffset, xyCtrOffset, 0];

module itemModule()
{
    difference()
    {
        // Exterior:
        wallXYZ = 3;
        extDiaXY = zAxisCOrnerDia + 2*wallXYZ;
        extZ = zAxisCOrnerHeight + wallXYZ;
         hull() doubleY() doubleX() translate(corner+[0,0,-zAxisCOrnerDia/2-wallXYZ]) simpleChamferedCylinderDoubleEnded(d=extDiaXY, h=extZ, cz=wallXYZ);

        // inside:
	    hull() doubleY() doubleX() 
        {
            translate(corner) sphere(d=zAxisCOrnerDia);
            translate(corner+[0,0,40]) sphere(d=zAxisCOrnerDia);
        }
    }
}

module clip(d=0)
{
	tc([-200, -400-d, -200], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
