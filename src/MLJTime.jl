module MLJTime

# IMPORTS
using IndexedTables, CSVFiles, ZipFile

# from Standard Library:
using Statistics, DecisionTree

# EXPORTS
export RandomForestClassifierTS, InvFeatureGen,
       predict_single, InvFeatures, predict_new,
       X_y_split
export load_dataset, load_gunpoint, TSdataset,
       univariate_datasets, load_ts_file

export L1
#CONSTANTS
# the directory containing this file: (.../src/)
const MODULE_DIR = dirname(@__FILE__)

# Includes
include("IntervalBasedForest.jl")
include("datapath.jl")
include("measures.jl")

end # module
