from Swoop.ext.ShapelySwoop import ShapelySwoop
from Swoop import From
import Swoop
import argparse
import solid
import sys



def make_package_scad(parts):
    dump = Swoop.ext.ShapelySwoop.GeometryDump("out", "out.pdf")
    holes = solid.square()()
    for h in From(brd).get_plain_elements().with_type(Swoop.Hole):
        print "{} {} {}".format(h.get_x(), h.get_y(), h.get_drill())
        geometry = h.get_geometry()
        print geometry
        #holes += solid.polygon([x for x in geometry.exterior.coords])
        dump.add_geometry(geometry, width=1)
    for h in From(brd).get_elements():
        if h.get_name() in parts:
            print h.get_name()

            geometry = h.get_geometry(layer_query="tKeepout")

            #holes += solid.polygon([x for x in geometry.exterior.coords])
            dump.add_geometry(geometry, width=1)
    dump.dump()
    return holes



parser = argparse.ArgumentParser(description="Send a bunch of emails")

parser.add_argument("--parts", required=False, type=str, nargs="+", help="parts to make holes for")
parser.add_argument("--brd", required=True,  help="Board to use")
parser.add_argument("--scad", required=True,  help="scad file output")

args = parser.parse_args()

brd = ShapelySwoop.open(args.brd)

output = make_package_scad(args.parts)

open(args.scad , "w").write("""
module {a}() {{
{b}
}}
""".format(a=args.brd[:-4].split("/")[-1].replace("-","_"), b=solid.scad_render(output)))

#"../Motor Driver/MotorDriver-rev1.brd")

#["J1", "J2", "J3", "J4"]