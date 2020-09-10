########################################################################################
#VisiumExperiment object with one imagePath and sample column in colData
#Brenda Pardo
########################################################################################


#Load required libraries
library(SingleCellExperiment)
library(SpatialExperiment)
library(spatialLIBD)
library(ExperimentHub)
library(jsonlite)
library(BiocFileCache)

#Connect to ExperimentHub
ehub <- ExperimentHub::ExperimentHub()

## Download sce object
if (!exists("sce")) sce <- fetch_data(type = "sce", eh = ehub)

#Load data
#Load assays
assays_visium=assays(sce)

#Load rowData
rowData_visium=rowData(sce)

#Load colData
colData_visium=colData(sce)[, c(2,8:73)]

#Load spatialCoords
spatialCoords_visium=colData(sce)[, c(1, 3:7)]
names(spatialCoords_visium)=c("Cell_ID", "in_tissue", "array_row", "array_col", "pxl_col_in_fullres", "pxl_row_in_fullres")

#Load scaleFactors
url_scaleFactors<- "https://raw.githubusercontent.com/LieberInstitute/HumanPilot/master/10X/151507/scalefactors_json.json"
scaleFactors_visium <- read_json(url_scaleFactors)

#Load reducedDim
reducedDimNames_visium=reducedDims(sce)

#Load images
url_images <- "https://spatial-dlpfc.s3.us-east-2.amazonaws.com/images/151507_tissue_lowres_image.png"

## Download images
bfc <- BiocFileCache()
filepath_images <- bfcrpath(bfc, url_images, exact = TRUE)


#Create object
sce_ve <- VisiumExperiment(rowData=rowData_visium,
                        colData=colData_visium,
                        assays=assays_visium,
                        spatialCoords=spatialCoords_visium,
                        scaleFactors=scaleFactors_visium,
                        imagePaths= filepath_images,
                        reducedDims=reducedDimNames_visium
                        )



########################################################################################
#VisiumExperiment object with multiple imagePaths and sample column in spatialCoords
#Brenda Pardo
########################################################################################
#Load colData
colData_visium=colData(sce)[, c(8:73)]

#Load spatialCoords
spatialCoords_visium=colData(sce)[, c(1:7)]
names(spatialCoords_visium)=c("Cell_ID", "sample_name", "in_tissue", "array_row", "array_col", "pxl_col_in_fullres", "pxl_row_in_fullres")

#Load images
sample_id=c(151507:151510, 151669:151676)

for(i in sample_id){
  url_images <- paste0("https://spatial-dlpfc.s3.us-east-2.amazonaws.com/images/", sample_id, "_tissue_lowres_image.png")
  bfc <- BiocFileCache()
  filepath_images <- bfcrpath(bfc, url_images, exact = TRUE)
  }

#Create object
sce_ve <- VisiumExperiment(rowData=rowData_visium,
                           colData=colData_visium,
                           assays=assays_visium,
                           spatialCoords=spatialCoords_visium,
                           scaleFactors=scaleFactors_visium,
                           imagePaths= filepath_images,
                           reducedDims=reducedDimNames_visium
                           )
