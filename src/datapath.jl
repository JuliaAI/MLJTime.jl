
const DATA_DIR = joinpath(MODULE_DIR, "..", "data")

function load_dataset(fname::String)
    fpath = joinpath(DATA_DIR, fname)
    data_raw = load(fpath, header_exists=false)
    Table = table(data_raw)
    data_table = MatrixI(Table)
    return data_table
end

function X_y_split(MatrixI::Array)
    l_index = length(MatrixI[1,:])
    return MatrixI[:, 1:l_index-1], MatrixI[:, l_index]
end


load_gunpoint() = load_dataset.(["GunPoint/train.csv", "GunPoint/test.csv"])

function MatrixI(table)
    cols = columns(table)
    n, p = length(cols[1]), length(cols)
    matrix = Matrix{Float64}(undef, n, p)
    for i=1:p
        matrix[:, i] = cols[i]
    end
    return matrix
end
#permutedims(cat(mat, mat2, dims=3),[1,3,2]) For Motions

function TSdataset(dataset::Array) #check on win
    for Dir in dataset
        exdir = string("data/", Dir)
        _link = string("http://timeseriesclassification.com/Downloads/", Dir ,".zip")
        Base.download(_link, Dir)
        fileFullPath = isabspath(Dir) ?  Dir : joinpath(pwd(), Dir)
        basePath = dirname(fileFullPath)
        outPath = (exdir == "" ? basePath : (isabspath(exdir) ? exdir : joinpath(pwd(),exdir)))
        isdir(outPath) ? "" : mkdir(outPath)
        zarchive = ZipFile.Reader(fileFullPath)
        for f in zarchive.files
            if f.name[end-1:end] == "ts"
                f.name = string(f.name[1:end-2], "csv")
                fullFilePath = joinpath(outPath,f.name)
                write(fullFilePath, read(f))
                open(fullFilePath) do input
                    readuntil(input, "@data")
                    write(fullFilePath, read(input))
                end
                run(`sed -i'.original' 's/:/,/g' $fullFilePath`)
                fullFilePath1 = string(fullFilePath, ".original")
                run(`rm $fullFilePath1`)
            end
        end
        close(zarchive)
        run(`rm $fileFullPath`)
    end
end

function TSdataset(filepath::String)
    exdir = string("data/", basename(filepath))
    fileFullPath = isabspath(filepath) ?  filepath : joinpath(pwd(), filepath)
    basePath = dirname(fileFullPath)
    outPath = (exdir == "" ? basePath : (isabspath(exdir) ? exdir : joinpath(pwd(),exdir)))
    isdir(outPath) ? "" : mkdir(outPath)
    files = readdir(fileFullPath, join=true)
    for f in files
        if f[end-1:end] == "ts"
            fullFilePath = joinpath(outPath, string(f[1:end-2], "csv"))
            write(fullFilePath, read(f))
            open(fullFilePath) do input
                readuntil(input, "@data")
                write(fullFilePath, read(input))
            end
            run(`sed -i'.original' 's/:/,/g' $fullFilePath`)
            fullFilePath1 = string(fullFilePath, ".original")
            run(`rm $fullFilePath1`)
        end
    end
end

"""
`load_ts_file(fpath)` takes the path to `.ts` files and returns the
 Table and Array.
"""
function load_ts_file(fpath)
#`readuntil` and `readlines` are used in combination so that we read data
# required only for transformation into julia array and table.
    data = open(fpath) do input
          readuntil(input, "@data")
          readlines(input)
    end
    data = data[2:end] # removes  the empty string.
    # split the string and convert each element into Float64.
    arrays = [parse.(Float64, split(i, r"[:,]")) for i in data]
    array = transpose(hcat(arrays...)) # Creates 2D Array.
    return table(eachcol(array)...), array
end

univariate_datasets = [
    "ACSF1",
    "Adiac",
    "AllGestureWiimoteX",
    "AllGestureWiimoteY",
    "AllGestureWiimoteZ",
    "ArrowHead",
    "Coffee",
    "Beef",
    "BeetleFly",
    "BirdChicken",
    "BME",
    "Car",
    "CBF",
    "Chinatown",
    "ChlorineConcentration",
    "CinCECGTorso",
    "Coffee",
    "Computers",
    "CricketX",
    "CricketY",
    "CricketZ",
    "Crop",
    "DiatomSizeReduction",
    "DistalPhalanxOutlineCorrect",
    "DistalPhalanxOutlineAgeGroup",
    "DistalPhalanxTW",
    "DodgerLoopDay",
    "DodgerLoopGame",
    "DodgerLoopWeekend",
    "Earthquakes",
    "ECG200",
    "ECG5000",
    "ECGFiveDays",
    "ElectricDevices",
    "EOGHorizontalSignal",
    "EOGVerticalSignal",
    "EthanolLevel",
    "FaceAll",
    "FaceFour",
    "FacesUCR",
    "FiftyWords",
    "Fish",
    "FordA",
    "FordB",
    "FreezerRegularTrain",
    "FreezerSmallTrain",
    "Fungi",
    "GestureMidAirD1",
    "GestureMidAirD2",
    "GestureMidAirD3",
    "GesturePebbleZ1",
    "GesturePebbleZ2",
    "Ham",
    "HandOutlines",
    "Haptics",
    "Herring",
    "InlineSkate",
    "InsectEPGRegularTrain",
    "InsectEPGSmallTrain",
    "InsectWingbeatSound",
    "ItalyPowerDemand",
    "LargeKitchenAppliances",
    "Lightning2",
    "Lightning7",
    "Mallat",
    "Meat",
    "MedicalImages",
    "MelbournePedestrian",
    "MiddlePhalanxOutlineCorrect",
    "MiddlePhalanxOutlineAgeGroup",
    "MiddlePhalanxTW",
    "MixedShapesRegularTrain",
    "MixedShapesSmallTrain",
    "MoteStrain",
    "NonInvasiveFetalECGThorax1",
    "NonInvasiveFetalECGThorax2",
    "OliveOil",
    "OSULeaf",
    "PhalangesOutlinesCorrect",
    "Phoneme",
    "PickupGestureWiimoteZ",
    "PigAirwayPressure",
    "PigArtPressure",
    "PigCVP",
    "PLAID",
    "Plane",
    "PowerCons",
    "ProximalPhalanxOutlineCorrect",
    "ProximalPhalanxOutlineAgeGroup",
    "ProximalPhalanxTW",
    "RefrigerationDevices",
    "Rock",
    "ScreenType",
    "SemgHandGenderCh2",
    "SemgHandMovementCh2",
    "SemgHandSubjectCh2",
    "ShakeGestureWiimoteZ",
    "ShapeletSim",
    "ShapesAll",
    "SmallKitchenAppliances",
    "SmoothSubspace",
    "SonyAIBORobotSurface1",
    "SonyAIBORobotSurface2",
    "StarlightCurves",
    "Strawberry",
    "SwedishLeaf",
    "Symbols",
    "SyntheticControl",
    "ToeSegmentation1",
    "ToeSegmentation2",
    "Trace",
    "TwoLeadECG",
    "TwoPatterns",
    "UMD",
    "UWaveGestureLibraryAll",
    "UWaveGestureLibraryX",
    "UWaveGestureLibraryY",
    "UWaveGestureLibraryZ",
    "Wafer",
    "Wine",
    "WordSynonyms",
    "Worms",
    "WormsTwoClass",
    "Yoga",
]
