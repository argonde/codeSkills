#!/usr/bin/ python3
# -*- coding: utf-8 -*-
# Generates PDFs or images from a QGIS Atlas composition.

import sys
import qgis.core as q
import argparse

# function that parses the input from the user, based on flags
parser = argparse.ArgumentParser()
parser.add_argument('-C',
                    metavar='\"Coverage Layer Name\"',
                    help='Usage: Override the atlas coverage layer')
parser.add_argument('-D',
                    metavar='\"Output Directory\"',
                    help='Usage: Override the output directory and include trailing "\\"')
parser.add_argument('-F', nargs=3,
                    metavar=('\"Column\"', '\"operator\"', '\"value\"'),
                    help='Usage: Override the Atlas filter')
parser.add_argument('-L',
                    metavar='\"Layout name\"', help='Usage: Override QGS layout manager')
parser.add_argument('-N',
                    metavar='\"Output Name\"',
                    help='''Usage: Override image output name using unique value query.
                    e.g. \"@atlas_featureid\"''')
parser.add_argument('-O',
                    metavar='\"Output Format\"',
                    help='Usage: Either "image" or "pdf" (default)')
parser.add_argument('-P',
                    metavar='\"Project file\"', help='Usage: Override QGS project file')
parser.add_argument('-Q',
                    metavar='\"Output pdf Name\"',
                    help='''Usage: Override output name for PDFs
                    (cannot parse column values as image filter can)''')

# call the function to accept user input
parser.parse_args()

# declare hardcoded variables, use the flags above for overriding them
base_path = r'P:/Company/department/team/workingDirectory/employee/_test/'
# -P = Project file
# In this case a .qgs file (an XML format for QGIS projects) containing layers & layouts
myProject = base_path + 'qgisAtlas.qgs'

# -L = Layout ("Layout name")
layoutName = None

# -C = Coverage Layer Name ("Layer Name")
coverageLayer = None

# -F = filter ("column" "operator" "value")
atlasFilter = ''

# -O = Output Format (pdf or image)
outputFormat = 'pdf'

# -D = Output Directory ("c:your\output" - include trailing "/")
outputFolder = base_path + r'_pdf/shell_auto/a/'

# -N = Image output Name
# e.g.\"Parish\" || \' \' || \"Number\" where parish and number are columns
outputName = '\"Grundvandsomr\"||\'_grvOmr_\'||\"GvomrNr\"'

# -Q = PDF Name
pdfName = '\"Grundvandsomr\"||\'_grvOmr_\'||\"GvomrNr\"'


# reset variables in accordance to received flags
if "-P" in sys.argv:
    myProject = sys.argv[sys.argv.index("-P") + 1]
if "-L" in sys.argv:
    layoutName = sys.argv[sys.argv.index("-L") + 1]
if "-C" in sys.argv:
    coverageLayer = sys.argv[sys.argv.index("-C") + 1]
if "-F" in sys.argv:
    atlasFilter = "\"" + sys.argv[sys.argv.index("-F") + 1] + \
                  "\" " + sys.argv[sys.argv.index("-F") + 2] +\
                  " \'" + sys.argv[sys.argv.index("-F") + 3] + "\'"
if "-O" in sys.argv:
    outputFormat = sys.argv[sys.argv.index("-O") + 1]
if "-D" in sys.argv:
    outputFolder = sys.argv[sys.argv.index("-D") + 1]
if "-N" in sys.argv:
    outputName = sys.argv[sys.argv.index("-N") + 1]
if "-Q" in sys.argv:
    pdfName = sys.argv[sys.argv.index("-Q") + 1]

# declare local variables
gui_flag = False

# initialise QGIS
app = q.QgsApplication([], gui_flag)
app.initQgis()
# notify user
print('Step1: qgis is on')

# Defining map path and contents
project = q.QgsProject.instance()
manager = project.layoutManager()
project.read(myProject)
print('step2: just read the .qgs file')


# auto-assign values to non-declared variables by fetching
if layoutName is None:
    layoutName = manager.layouts()[0]

# function to allow selecting a visible (active) layer on Qgis
checked_layers = [layer.name() for layer
                  in q.QgsProject().instance().layerTreeRoot().children()
                  if layer.isVisible()]
# provide a default
if coverageLayer is None:
    coverageLayer = checked_layers[1]
a = layoutName.name()
print('step3: got the layout and coverage layer')
print('       layout: ' + a[:] + ', coverage layer: ' + coverageLayer)


# Create the printing map Atlas
myAtlas = layoutName.atlas()
# atlas query
cl_path = 'R:/Data/16_GIS/Database/MI/MI_Gvomr.TAB'
cLayer = q.QgsVectorLayer(cl_path, 'MI_Gvomr', "ogr")
cLayer.isValid()
myAtlas.setCoverageLayer(cLayer)
myAtlas.setEnabled(True)
myAtlas.setHideCoverage(False)
myAtlas.setFilterFeatures(True)
myAtlas.setFilterExpression(atlasFilter)


# declare the image and pdf settings
pdf_settings = q.QgsLayoutExporter.PdfExportSettings()
image_settings = q.QgsLayoutExporter.ImageExportSettings()
image_settings.dpi = 200
imageExtension = '.png'


# work with QgsLayoutExporter object
exporter = q.QgsLayoutExporter(layoutName)
if not cLayer:
    print(coverageLayer + " failed to load!")
    pass
features = cLayer.getFeatures()
attrs = ()
outId = 1  # output map counter
print('step4: ready to export files')


# export the images or PDF (depending on flag)
if outputFormat == 'pdf':
    exporter.exportToPdfs(myAtlas, outputFolder + pdfName + '.pdf',
                          pdf_settings)
    print(pdfName+'.pdf is printed out')
else:
    exporter.exportToImage(myAtlas, outputFolder + outputName,
                           imageExtension, image_settings)
    print(outputName + '.' + imageExtension + ' is printed out')


project.clear()
app.exitQgis()
print("Job done!")
