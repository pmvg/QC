# qc.test information:
#
# Description
#
# This function test daily sunset values to max daily value that could take and optionally
# test with mean or sum according to case applied.
# 
# In some publications papers, after a certain date and in some places, sunshine hours start to be designated by "insolation".
# Diference between both is in units, ie. sunshine hours its in hour.minuts units and insolation in hours units.
# So sunshine hours = insolation. Based on "C3S-DRS guideline" variable take name of sunshine hours(ss)
# and units = hours(h), meaning that all values that are in hour.minuts will be convert to only hours,
# making a metadata observation of original values.
#
# Usage
#
# qc.test ()
# qc.test (fileRead="file.csv", fileFmt="SEF", fileHead=TRUE, meanchk=FALSE, vname="ss")
# qc.test ("file.csv","SEF",F,F,"sshm")
#
# Arguments:
#
# fileRead         can write file name, this should be in R work directory if no path attach.
#                  Default: ask for file. 
#
# fileFmt          character, format of data file that goes to be read. It takes three options
#                  "ERACLIM", "SEF" or "other".
#                  First two are space or tab delimited files. Default: "SEF"
#
# fileHead         logical, say if file with data have header. Default: TRUE.
#
# meanchk          logical, trigger chance to test mean or sum published with calculated within
#                  function. Default: FALSE.  
#
# vname            character, can specify name of variable, in this case is only two options 
#                  regarding sunshine hours and units used, "sshm" for sunshine hours with units: hours.minuts and 
#                  "ss" for insolation or total insolation with units: hours. 
#                  Default: "ss".
#
#
# Details
#
# This function does:
# gathering information, data and means/sum (if exist);
# test sunshine hours with max hours that can take one place for determinate date;
# test sunshine hours publish mean/sum with calculated by function with data values gathered, if applied.
#
# Variables necessary to run:
# Year, Month, Day, latitude, longitude, alt
#
# It reads from .csv or .txt files. 
#
# Formats of file that goes to read:
# Files with single or multiple variables with or without code atribute (var_code) and with
# variavel values (Value), like pre-format files stablish in others projects or work groups
# that will be used as defaults ("ERACLIM" and "SEF"). 
# (This are tab or space delimited text files and have header)
#  
#  "ERACLIM" project files (13 col):
#   [Uniq_rec_ID][Lon][Lat][Alt][Year][Month][Day][Hour][Tflag][VarN][Var_val][Varflag][DeepZ]
#   
#  "SEF" 0.2.0 (8 col): [Year][Month][Day][Hour][Minute][Period][Value][Meta]
#                     (this file also contains metadata in first twelve lines)
#
# "other" formats, as:
#
#   Files with or without header, but with struture like [Var_code][Year][Month][Day][Hour][Minute][Value] or
#   similar
#
#   Files with multiple variables, with header present and with short names according with 
#   C3S-DRS guideline, sunshine column values header should be "ss",
#    [Year][Month][Day][Var1][ss]...[VarN] <- header for first line
#
# Note: Any format that will be read, must at least contain columns with [Year][Month][Day][Value]
#
# In case of mean/sum test, file with data published should be of type txt or csv 
# and format: [Year][Month][Hour][Minute][Value] or [Year][Month][Value] or [Var_code][Year][Month][Value].
#
# file named "QC_info.txt"
# In R work directory, will be created with metadata and info need to run, working
# as a backup or in case of re-run for same station. This file contains variables definition
# needed to obtain max sunset hours for a determinate location and on certain date
# (function: day.duration()). 
# This file can contain the follow variables:
#
# lat           latitude in degrees of station   (default: 999.9)
# long          longitude in degrees of station  (default: 999.9)
# alt           altitude of station              (default: 0.0)
# data_error    data error value                 (default: -99.9)
# varcod        variavel code (if applied)       (default: -999)
# (optional)
# years         if year is not present inside data file, user can include it manually. (default: 9999)
# 
# "QC_info.txt" exemple:
#                                
# lat  <- 38.7                  
# long <- -9.1                  
# alt  <- 95                     
# data_error <- NA           
# varcod <- -999              
# years <- 9999   
#
# In case of no lat and long coordenates is possible to get it if degree,minuts,seconds and direction coordenates
# values exist. Function will ask for it.
#
# lat_deg, lat_min, lat_sec    (default: 999)
# lat_dir                      (default: "-")
# long_deg, long_min, long_sec (default: 999)
# long_dir                     (default: "-")
#
# If file "QC_info.txt" exist, function will ask if want to use it. If not then some variables need to be set for
# qc.test and sub-functions run normally. Optional variables can be define by open file and 
# manually had it and then re-run. In case of file format (fileFmt) is equal to "ERACLIM", it's adviced to asw "no"
# if want to use this file, since variables will be defined by default values and that dont pass on check. this happen
# because ERACLIM format includes metadata inline with values, not separated. 
#
# Dependency of foward function:
# day.duration (my_year,my_month,my_day)                
#   arguments: my_year, my_month, my_day;
#   calculates max solar hours day can take for a certain day, month, year and place;
# lat.calc()     
#   variables: lat_deg, lat_min, lat_sec, lat_dir (asked in running)
#   calculates latitude in degrees;
# long.calc()
#   variables: long_deg, long_min, long_sec, long_dir (asked in running)
#   calculates longitude in degrees.
#
# Output files
# QC_info.txt, with metadata and info from localization and data series
# file_out.txt, with table and metadata from QC test function
# log.txt, run log of function.
#
# Exemples 
# 1) qc.test("test.csv",,,TRUE) or qc.test("test.csv",,,T)
#      fileRead = "test.csv"
#      fileFmt  = "SEF" (default)
#      fileHead = TRUE  (default)
#      meanchk  = TRUE
#      vname    = "ss" (default)
#
# 2) qc.test("test.csv",fileHead=T,meanchk=T) 
#      fileRread = "test.csv"
#      fileFmt   = "SEF"
#      fileHead  = TRUE
#      meanchk   = TRUE
#      vname     = "ss" (default)
#
# 3) qc.test(meanchk=T)
#      fileRead = (will open a window to choose)
#      fileFmt  = "SEF" (default)
#      fileHead = TRUE  (default)
#      meanchk  = TRUE
#      vname    = "ss"  (default)
#
# 4) qc.test(,"SEF",F,T,"sshm")
#      fileRead = (will open a window to choose)
#      fileFmt  = "SEF" 
#      fileHead = FALSE  
#      meanchk  = TRUE
#      vname    = "sshm"
#
# 5) qc.test()
#      fileRead = (will open a window to choose)
#      fileFmt  = "SEF" (default)
#      fileHead = TRUE  (default)
#      meanchk  = FALSE (default)
#      vname    = "ss"  (default)
#
# If user only want to specify one argument, have to write name of argument like exemple 3) above.
# If user don't write name of argument like exemple 1), then its extremely necessary to keep the order of each one. 
#
# End information
#
qc.test<-function(fileRead = file.choose(),fileFmt="SEF",fileHead = TRUE, meanchk = FALSE, vname = "ss"){
#  
writeLines("PART 1: Checking functions need to run and read table files")
#
assign("fileFmt",fileFmt,envir = globalenv())
assign("fileHead",fileHead,envir = globalenv())
assign("meanchk",meanchk,envir = globalenv())
assign("vname",vname,envir = globalenv())
if (file.exists("log.txt")) {
  writeLines("Log file already exist...")
  choice <- askYesNo("Delete log file?", default = FALSE)
  if (choice){
    file.remove("log.txt")
    cat(date(), file="log.txt", sep = " ", fill = TRUE)
  } else {cat(date(), file="log.txt", sep = " ", fill = TRUE, append = TRUE)}
} 
if (exists("day.duration", mode = "function")) {
  writeLines("All functions need present. Continuing...")
} else {if (file.exists("sunshine_func.R")){source("sunshine_func.R")} else {
    writeLines("One or more functions necessary is not present!!!)")
    cat("day.duration function not found",file = "log.txt",append = TRUE)
    stop()}
}
if (file.exists("Qc_info.txt")) {
  choice <- askYesNo("File Qc_info.txt exits, want to use it?")
  if (choice) {
    source("QC_info.txt")
    if (exists("lat")) {
      if (lat < -90 | lat > 90) {
        writeLines("Latitude not correct!!")
        cat("Latitude not correct!!",file="log.txt",append = TRUE)
        stop()}      
    } else {choice <- FALSE}
    if (exists("long")) {
      if (long < -180 | long > 180) {
        writeLines("Longitude not correct!!")
        cat("Latitude not correct!!",file="log.txt",append = TRUE)
        stop()}
    } else {choice <- FALSE}
    if (exists("alt")) {
      if (alt < 0.0) {
        writeLines("Incorrect altitude, default in place!!")
        cat("Incorrect altitude, default in place!!",file="log.txt",append = TRUE)
        alt <- 0.0}    
    } else {choice <- FALSE}
  } else {file.remove("QC_info.txt")}
} else {choice <- FALSE} 
if (choice != TRUE) {
  if (fileFmt == "SEF") {
    #  fileHead <- TRUE
    #  fileRead <- file.choose()
    data_meta <- read.delim(fileRead, header= FALSE, stringsAsFactors = FALSE, sep = "\t", quote = "", nrows = 12, col.names = c("opts","val"))
    #  print(data_meta)  
    lat  <- as.numeric(data_meta$val[data_meta$opts == "Lat"])
    long <- as.numeric(data_meta$val[data_meta$opts == "Lon"])
    alt  <- as.numeric(data_meta$val[data_meta$opts == "Alt"])
  } else if (fileFmt == "ERACLIM") {
    #  file_read <- file.choose()
    writeLines("Format is ERACLIM. Metadata need included along with data values")
    cat("Format is ERACLIM. Metadata included with data values", file="log.txt", fill = TRUE, append = TRUE)  
    lat  <- -999.9
    long <- -999.9
    alt  <- 0.0
  } else {
    writeLines("Before continue we need to define some variables")
    choices <- menu(c("in degree","in degree min sec dir"), graphics = TRUE, title = "Define coordenates:")
    if (choices == 1) {
      lat  <- as.numeric(readline("Introduce latitude in degrees:  "))
      long <- as.numeric(readline("Introduce longitude in degrees:  "))  
      if (lat < -90 | lat > 90) {
        writeLines("Latitude not correct!!")
        cat("Latitude not correct!!",file="log.txt",append = TRUE)
        stop()}
      if (long < -180 | long > 180) {
        writeLines("Longitude not correct!!")
        cat("Latitude not correct!!",file="log.txt",append = TRUE)
        stop()}
    } else if (choices == 2) {
      lat  <- lat.calc()
      cat ("Latitude in degrees is: ",lat, fill = TRUE)
      long <- long.calc()
      cat ("Longitude in degrees is: ",long, fill = TRUE)}
    # Altitude of station
    if (exists("alt")) {
      if (alt < 0.0) {
        writeLines("Incorrect altitude, default in place!!")
        cat("Incorrect altitude, default in place!!",file="log.txt",append = TRUE)
        alt <- 0.0}    
    } else {
      alt <- as.numeric(readline("Introduce altitude of station:  ")) 
      if (alt < 0.0) {
        writeLines("Incorrect altitude, default in place!!")
        cat("Incorrect altitude, default in place!!",file="log.txt",append = TRUE)
        alt <- 0.0}
    }
  }
  assign("lat", lat, envir = globalenv())
  assign("long", long, envir = globalenv())
  assign("alt", alt, envir = globalenv())
  # data_error  
  data_error <- readline("Introduce data error value:  ")
  if (nchar(data_error) == 0) {
    writeLines("No data error defined, default in place!!")
    cat("No data error defined, default in place!!",file="log.txt",append = TRUE)
    data_error <- -99.9}
  cat("data_error <-",data_error, file="QC_info.txt", fill = TRUE, append = TRUE)
  # varcod, if variable has a code use it, becomes necessary if data file have multiple variables
  varcod <- readline("Introduce variable code (no code put -999): ")
  if (nchar(varcod) == 0) {
    writeLines("Variable code not defined, function may not work if data file have multiple variables")
    cat("Variable code not defined, function may not work if data file have multiple variables",file="log.txt",append = TRUE)
    varcod <- -999}
  cat("varcod <-'",varcod,"'", file = "QC_info.txt", sep = "", fill = TRUE, append = TRUE)
  assign("data_error", data_error, envir = globalenv())
  assign("varcod", varcod, envir = globalenv())
}
#
# PART 1: End
#
writeLines("PART 2: Reading table files according with type and format")
writeLines("----> data file <----")
#
assign("fileRead",fileRead,envir = globalenv())
read.file()
#
# PART 2: End
#
writeLines("PART 3: Header Checks")
#
if (fileFmt == "ERACLIM") {
  data_names <- variable.names(data_val)
  for (i in 1:length(data_names)){
    if (data_names[i] == "Var_val" | data_names[i] == "var_val"){data_names[i] <- "Value"}
    if (data_names[i] == "VarN" | data_names[i] == "varN"){data_names[i] <- "Var_code"} 
  }
#  assign("data_names", data_names, envir = globalenv())
  names(data_val) <- data_names
  assign ("data_val", data_val, envir = globalenv())  
}
if (fileFmt == "other") {
  data_header <- c(FALSE,FALSE,FALSE,FALSE,FALSE)
  if (fileHead == TRUE){
    data_names <- variable.names(data_val)
    #  assign("data_names", data_names, envir = globalenv())
    #  print(data_names)
    for (i in 1:length(data_names)){
      if (data_names[i] == "year" | data_names[i] == "Year"){
        data_names[i] <- "Year"
        data_header[1]<- TRUE}
      if (data_names[i] == "month" | data_names[i] == "Month"){
        data_names[i] <- "Month"
        data_header[2]<- TRUE}
      if (data_names[i] == "day" | data_names[i] == "Day"){
        data_names[i] <- "Day"
        data_header[3]<- TRUE}
      if (data_names[i] == "value" | data_names[i] == "Value"){
        data_names[i] <- "Value"
        data_header[4]<- TRUE} 
      if (data_names[i] == "Var_val" | data_names[i] == "var_val"){
        data_names[i] <- "Value"
        data_header[4]<- TRUE}
      if (data_names[i] == "ss"){
        data_names[i] <- "Value"
        data_header[4]<- TRUE} 
      if (data_names[i] == "VarN" | data_names[i] == "varN"){
        data_names[i] <- "Var_code"
        data_header[5]<- TRUE} 
      if (data_names[i] == "Var_code" | data_names[i] == "var_code"){
        data_names[i] <- "Var_code"
        data_header[5]<- TRUE}
    }
    if (data_header[1] & data_header[2] & data_header[3]){writeLines("Date values exist, continuing...")} else {
      writeLines("Miss some date values, please correct and run again.")
      cat("Year=",data_header[1],"Month=",data_header[2],"Day=",data_header[3], sep = " ", fill = TRUE)
      cat("Miss some date values, please correct and run again.", file = "log.txt", sep = " ", fill = TRUE, append = TRUE)
      cat("Year=",data_header[1],"Month=",data_header[2],"Day=",data_header[3], file = "log.txt", sep = " ", fill = TRUE, append = TRUE)
      stop()}
    if (data_header[4]) {writeLines("column with name Value is present. Continuing....")} else{
      writeLines("Value column dont exists to test!!!")
      data_name_sub <- data_names[data_names != "Year" & data_names != "Month" & data_names != "Day"]
      print(data_name_sub)
      choice <- askYesNo("Any of column names above is to test?")
      if (choice == TRUE) {
        asw <-select.list(data_name_sub,preselect = NULL, multiple = FALSE, title = "Choose?", graphics = TRUE)
        for (i in 1:length(data_names)){
          if (data_names[i] == asw){
            data_names[i] <- "Value"
            data_header[4] <- TRUE}
        }
      } else {
        writeLines("No column exists to test!! Program will stop.")
        cat("No column exists to test!!",file="log.txt",append = TRUE)
        stop()}
    }
#    assign("data_names", data_names, envir = globalenv())
    names(data_val) <- data_names
    assign ("data_val", data_val, envir = globalenv()) 
  } else {
    data_header <- c()
    if (ncol(data_val) < 4) {
      writeLines("File should contain at least 4 columns: Year,Month,Day and Value")
      writeLines("Error on reading data file")
      cat("Error on reading data file, at least 4 columns needed!!",file="log.txt",append = TRUE)
      stop()} else {
      writeLines("Use CTRL or SHIFT to choose more than one")
      writeLines("Number of columns to choose: ")
      print(ncol(data_val))
      opt_val <- c("rec_ID","Lon","Lat","Alt","Var_code","Year","Month","Day","Hour","Minute","Tflag","Var_code","Period","Value","Meta","Varflag","DeepZ")
      data_names <- select.list(opt_val,preselect = NULL, multiple = TRUE, title = "Header Choose", graphics = TRUE)
      cat ("Header Names choosed:", data_names, sep = " ", fill = TRUE, append = TRUE)
      names(data_val) <- data_names
#      assign ("data_names", data_names, envir = globalenv())
      assign ("data_val", data_val, envir = globalenv())}
    for (i in 1:length(data_names)){
      if (data_names[i] == "Year"){data_header[1]<- TRUE}
      if (data_names[i] == "Month"){data_header[2]<- TRUE}
      if (data_names[i] == "Day"){data_header[3]<- TRUE}
      if (data_names[i] == "Value"){data_header[4]<- TRUE} 
      if (data_names[i] == "Var_code"){data_header[5]<- TRUE}
    }
  }
}
if (meanchk) {
  if (fileHead) {
    data_names_sum <- variable.names(data_sum)
    cat("Mean header:",data_names_sum, sep = " ", fill = TRUE)
  } else {
    if (ncol(data_names_sum) == 3) {
      data_names_sum <- c("Year","Month","Value")
    } else {
      writeLines("Use CTRL or SHIFT to choose more than one")
      writeLines("Number of columns to choose: ")
      cat("Number of columns:",ncol(data_names_sum), sep = " ", fill = TRUE)
      print(ncol(data_sum))
      opt_val1 <- c("Var_code","Year","Month","Day","Hour","Minute","Value")
      data_names_sum <- select.list(opt_val1,preselect = NULL, multiple = TRUE, title = "Header Choose", graphics = TRUE)
      cat ("Header Names choosed:", data_names_sum, sep = " ", fill = TRUE, append = TRUE)
      names(data_sum) <- data_names_sum 
      assign ("data_sum", data_sum, envir = globalenv())}
  }
}
#
# PART 3: End
#
writeLines("PART 4: Checks")
writeLines("Checking ... data error value and attribute NA to it if not already is")
writeLines("             varcod is present (files ERACLIM type, multiple variables in one file)")
writeLines("             length of data series")
writeLines("             if variable is in Hours or hours and min")
#
# check data error value and pass to "NA"
data_val$Value[data_val$Value == data_error] <- NA
data_val$Value[data_val$Value == -99.9] <- NA
data_val$Value[data_val$Value == -999.9] <- NA
data_val$Value[data_val$Value == -999] <- NA
data_val$Value[data_val$Value == -9999] <- NA
if (meanchk){
data_sum$Value[data_sum$Value == data_error] <- NA
data_sum$Value[data_sum$Value == -99.9] <- NA
data_sum$Value[data_sum$Value == -999.9] <- NA
data_sum$Value[data_sum$Value == -999] <- NA
data_sum$Value[data_sum$Value == -9999] <- NA
}
#
# Check if Var_code present and varcod is defined 
if (fileFmt == "ERACLIM") {
  if (exists("varcod")) {
    if (varcod != -999 | varcod != "-999") {
      data_sub <- data_val[data_val$Var_code == varcod, ]
      if (length(data_sub$Value) != length(data_val$Value)) {
        if (length(data_sub$Value) == 0) {
          writeLines("Varcod doesnt exist in data series!!")
          cat("Varcod doesnt exist in data series!!", file = "log.txt", sep = " ", fill = TRUE, append = TRUE)
          choice <- askYesNo("Continue?", default = TRUE)
          if (choice != TRUE){stop()}
        } else {
          data_original <- data_val
          data_val <- data_sub 
          assign ("data_val", data_val, envir = globalenv())}
      }
    } else {writeLines("Varcod is not defined!")}    
  }
}
if (fileFmt == "other") {
  if (data_header[5]) {
    if (exists("varcod")) {
      if (varcod != -999 | varcod != "-999") {
        data_sub <- data_val[data_val$Var_code == varcod, ]
        if (length(data_sub$Value) != length(data_val$Value)) {
          if (length(data_sub$Value) == 0) {
            writeLines("Varcod doesnt exist in data series!!")
            cat("Varcod doesnt exist in data series!!", file = "log.txt", sep = " ", fill = TRUE, append = TRUE)
          } else {
            data_original <- data_val
            data_val <- data_sub 
            assign ("data_val", data_val, envir = globalenv())}
        }
      } else {writeLines("Varcod is not defined!")}    
    } 
  } else {writeLines("Varcod is not defined!")}  
}
#
#check data length
data_len <- length(data_val$Value)
#print(data_len)
assign("data_len",data_len,envir = globalenv())
#
# Define variable for metadata
Meta <- c()
for (i in 1:data_len){Meta[i] <- NA}
# check if variable is in Hours or hours and min
if (vname == "sshm" | vname == "ss") {
  for (i in 1:data_len) {
    dec_val <- data_val$Value[i]-floor(data_val$Value[i])
    if (is.na(dec_val)) {
      writeLines("Error value found...")
      cat("Year:",data_val$Year[i],"Month:",data_val$Month[i],"day:",data_val$Day[i], sep = " ", fill = TRUE)
    } else {
      if (dec_val > 0.601) {
        if (vname == "sshm") {
          writeLines("Warning:")
          cat("Year:",data_val$Year[i],"Month:",data_val$Month[i],"day:",data_val$Day[i], sep = " ", fill = TRUE)
          writeLines("Value can be already in hour units, this can lead to wrong test result. Verify is need.")
          cat("Year:",data_val$Year[i],"Month:",data_val$Month[i],"day:",data_val$Day[i],"vname = 'sshm', but value can be in hours units", file = "log.txt", sep = " ", fill = TRUE, append = TRUE)
          choice <- askYesNo("Conversion anyway?", default = FALSE)
          if (choice) {
            dec_val <- (data_val$Value[i]-floor(data_val$Value[i]))/0.6
            data_old <- data_val$Value[i]
            data_val$Value[i] <- round(floor(data_val$Value[i]) + dec_val, digits = 1)
            Meta[i] <- paste("Orig=",data_old, sep = "")
          } else {writeLines("No conversion by user choice. Continue testing...")}
        }
      } else {
        if (vname == "sshm") {
          dec_val <- dec_val/0.6
          data_old <- data_val$Value[i]
          data_val$Value[i] <- round(floor(data_val$Value[i]) + dec_val, digits = 1)
          Meta[i] <- paste("Orig=",data_old, sep = "")}
      }
    }
    #  print(dec_val)
  }
  assign("data_val", data_val, envir = globalenv())
}
#
# PART 4: End
#
writeLines("PART 5: Calculations and Tests")
#   Max Sunshine test
#
if (vname == "sshm" | vname == "ss"){
  writeLines("Testing max sunshine...")
  max_day <- c()
  for (i in 1:data_len){
    if (fileFmt == "ERACLIM") {
      lat <- data_val$Lat[i]
      long <- data_val$Lon[i]
      alt <- data_val$Alt[i]
      assign("lat", lat, envir = globalenv())
      assign("long", long, envir = globalenv())
      assign("alt", alt, envir = globalenv())}
    max_day[i] <- day.duration(data_val$Year[i],data_val$Month[i],data_val$Day[i])
    max_day[i] <- round(max_day[i],digits = 1)
    if (is.na(data_val$Value[i])) {
      writeLines("Error value found...")
      cat("Year:",data_val$Year[i],"Month:",data_val$Month[i],"day:",data_val$Day[i], sep = " ", fill = TRUE)      
    } else {
      if (data_val$Value[i] > max_day[i]){
        cat("Year:",data_val$Year[i],"Month:",data_val$Month[i],"day:",data_val$Day[i], sep = " ", fill = TRUE)
        cat("max sunshine hours:",max_day[i], sep = " ", fill = TRUE)
        cat("    sunshine hours:",data_val$Value[i], sep = " ", fill = TRUE)
        cat("Year:",data_val$Year[i],"Month:",data_val$Month[i],"day:",data_val$Day[i],"Flag raised: max_sunshine", file = "log.txt", sep = " ", fill = TRUE, append = TRUE)
        if (is.na(Meta[i])) {Meta[i] <- "max"} else {Meta[i] <- paste(Meta[i],"max", sep = ",")}}
    }
  }
  assign("max_day", max_day, envir = globalenv())
}
cat("lat  <-",lat, file="QC_info.txt", fill = TRUE, append = TRUE)
cat("long <-",long, file="QC_info.txt", fill = TRUE, append = TRUE)
cat("alt  <-",alt, file="QC_info.txt", fill = TRUE, append = TRUE)
#
#  Comparation with mean values
if (meanchk) {
  writeLines("Testing mean...")
# Check of number of years
  max_years <- max(data_val$Year)
  min_years <- min(data_val$Year)
  num_years <- max_years - min_years + 1
  cat("Number of Years:", num_years, sep = " ", fill = TRUE)
#
  for (i in min_years:max_years) {
    for (j in 1:12) {
      data_val_sub <- data_val[data_val$Year == i & data_val$Month == j, ]
      if (length(data_val_sub$Value) == 0) {
        cat("Year",i,"and Month",j,"dont exist...", sep = " ",fill = TRUE)
        cat("Year",i,"and Month",j,"dont exist...",file = "log.txt", sep = " ",fill = TRUE)
      } else {
        data_val_sum <- round(sum(data_val_sub$Value, na.rm = TRUE),digits = 2) 
        data_sum_sum <- data_sum$Value[data_sum$Year == i & data_sum$Month == j]
        if (vname == "sshm") {
          dec_val <- (data_sum_sum - floor(data_sum_sum))/0.6  
          data_sum_s <- floor(data_sum_sum) + dec_val
          data_sum_sum <- round(data_sum_s,digits = 2)}
        dif_val <- round(abs(data_val_sum - data_sum_sum),digits = 2)
        if (dif_val >= 0.1){
          cat("Sum: Year:",i,"Month:",j, sep = " ", fill = TRUE)
          cat("sunshine hours publish    :",data_sum_sum, sep = " ", fill = TRUE)
          cat("sunshine hours calculated :",data_val_sum, sep = " ", fill = TRUE)
          cat("Diference                 :",dif_val, sep = " ", fill = TRUE)
          cat("Year:",i,"Month:",j,"Flag raised: mean_sunshine", file = "log.txt", sep = " ", fill = TRUE, append = TRUE)
          for (k in 1:data_len) {
            if (data_val$Year[k] == i & data_val$Month[k] == j) {
              if (is.na(Meta[k])) {Meta[k] <- "mean"} else {Meta[k] <- paste(Meta[k],"mean", sep = ",")}}
          }
        }
      }
    }
  }
}
#
# PART 5: End
#
writeLines("PART 6: Write to files")
#
#
sefFmt <- FALSE
if (fileFmt != "SEF"){
  choice <- askYesNo("Write in SEF format?", default = "FALSE")
  if (choice == TRUE){
    sefFmt <- TRUE
    opts <- c("SEF","ID","Name","Lat","Lon","Alt","Source","Link","Vbl","Stat","Units","Meta")
    val  <- c("0.2.0","","","","","","","","","","","")
    data_meta <- data.frame(opts,val,stringsAsFactors = FALSE)
    if (fileFmt == "ERACLIM"){data_meta$val[data_meta$opts == "ID"] <- data_val$Uniq_rec_ID[1]}
    data_meta$val[data_meta$opts == "Name"] <- readline("Station Name?  ")
    data_meta$val[data_meta$opts == "Lat"]  <- lat
    data_meta$val[data_meta$opts == "Lon"]  <- long
    data_meta$val[data_meta$opts == "Alt"]  <- alt
    data_meta$val[data_meta$opts == "Vbl"]  <- vname
    if (vname == "sshm"){data_meta$val[data_meta$opts == "Vbl"] <- "ss"} 
    data_meta$val[data_meta$opts == "Units"] <- "hours"
    assign("data_meta",data_meta,envir = globalenv())
    Year   <- data_val$Year
    Month  <- data_val$Month
    Day    <- data_val$Day
    Period <- c()
    Hour   <- c()
    Minute <- c()
    for (i in 1:data_len){
      Hour[i]   <- substr(data_val$Hour[i], start= 1, stop = 2)
      Minute[i] <- substr(data_val$Hour[i], start= 3, stop = 4)
      Period[i] <- " " 
    }
    Value  <- round(data_val$Value,digits = 1)
    data_val <- data.frame(Year,Month,Day,Hour,Minute,Period,Value,stringsAsFactors = FALSE)
    assign("data_val",data_val,envir = globalenv())
  }  
}
writeLines("Default output file: file_out.txt")
choice <- askYesNo("Choose name for output file?", default = "FALSE")
if (choice){file_out <- file.choose()} else {
  file_out <- "file_out.txt"
  if (file.exists("file_out.txt")) {
    writeLines("File out already exists. Old file will be renamed to file_out_old.txt")
    file.rename("file_out.txt", "file_out_old.txt")}
}
for (i in 1:data_len){

}
if (exists("data_print")) {rm("data_print")}
if ("Meta" %in% colnames(data_val)) {
  writeLines("Meta column present, update new information...")
  for (i in 1:data_len) {
    if (is.na(data_val$Meta[i])) {data_val$Meta[i] <- Meta[i]} else {data_val$Meta[i] <- paste(data_val$Meta[i],Meta[i], sep = ",")}   
  }
  data_print <- data_val
} else {
  writeLines("Meta column not present, add information...")
  data_print <- cbind(data_val,Meta, stringsAsFactors = FALSE)
}
for (i in 1:data_len) {
  if (is.na(data_print$Value[i])){data_print$Value[i] <- data_error} 
  if (is.na(data_print$Meta[i])){data_print$Meta[i] <- ""}
}
if (fileFmt == "SEF" | sefFmt == TRUE) {
  write.table (data_meta, file = file_out, sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)  
}
write.table (data_print, file = file_out, append = TRUE, sep = "\t", quote = FALSE, row.names = FALSE, col.names = fileHead)
#
# PART 6: End
#
# End function
#
}
#
day.duration <- function(my_year,my_month,my_day) {
#
# define test values
#my_year  <- 1977
#my_month <- 1
#my_day   <- 15
#alt      <- 95.0
#
# Julian day number (of date user want)
jdn1 <- (1461*(my_year+4800+(my_month-14)/12))/4
jdn2 <- (367*(my_month-2-12*((my_month-14)/12)))/12
jdn3 <- (3*((my_year+4900+(my_month-14)/12)/100))/4
jdn4 <- my_day-32075
jd   <- c(jdn1,jdn2,-jdn3,jdn4)
jdn  <- sum (jd)
# n = number of days since 1/1/2000 12:00
n <- jdn-2451545.0+0.0008   
# mean solar noon
jmean <- n-(long/360.0)
# Solar mean anomaly m
m1 <- 357.5291+(0.98569928*jmean)
m <- m1 %% 360
mrad <- (m*pi)/180.0
mrad1 <- 2*mrad
mrad2 <- 3*mrad
# Equation of center
c <- (1.9148 * sin(mrad))+(0.0200 * sin(mrad1))+(0.0003 * sin(mrad2))
# Ecliptic longitude
lambda1 <- m+c+180.0+102.9372
lambda <- lambda1 %% 360
lambdarad <- (lambda*pi)/180.0
#Solar transit
#jtransit <- 2451545.0 + jmean + (0.0053*sin(mrad)) - (0.0069*sin(2*lambdarad))
# declination of the sun
delta1 <- sin(lambdarad) * sin(0.409105)  #23.44 = 0.409105 rad
delta <- asin(delta1)
# hour angle (w)
if (alt > 200.0) {correc <- -0.83 - ((2.076*sqrt(alt))/60)} else {correc <- -0.83}
#print(correc)
correc_rad <- (correc*pi)/180.0
lat_rad <- (lat*pi)/180.0
w1 <- sin(correc_rad) - (sin(lat_rad)*delta1)
w2 <- cos(lat_rad)*cos(delta)
w3 <- w1 / w2
w <- acos(w3)
w <- (w*180.0)/pi
#sunset (in julian)
#sunset <- jtransit + (w/360.0)
#sunrise (in julian)
#jsunrise <- jtransit - (w/360.0)
max_solar_day <- (w/15)*2
if (max_solar_day > 24.0) {max_solar_day <- 24.0} 
if (max_solar_day < 0.0) {max_solar_day <- 0.0}
return(max_solar_day)
#print(max_solar_day)
}
# end function day.duration
#
lat.calc <- function() {
#
lat_deg <- as.numeric(readline("Introduce latitude degrees:  "))
lat_min <- as.numeric(readline("Introduce latitude minuts:  "))
lat_sec <- as.numeric(readline("Introduce latitude seconds:  "))
lat_dir <- as.character(readline("Introduce latitude direction:  "))
# calculating lat_degree:
writeLines("Calculating Latitude in degrees...")
if (lat_deg < -90 | lat_deg > 90) {
  writeLines("Latitude degrees not correct!!")
  stop()} 
if (lat_min >= 0 & lat_min <= 60) {minuts <- lat_min/60.} else {minuts <- 0.0}
if (lat_sec >= 0 & lat_sec <= 60) {seconds <- lat_sec/3600.} else {seconds <- 0.0}
lat <- lat_deg + minuts + seconds
if (lat_dir == "s" | lat_dir == "S" | lat_dir == "n" | lat_dir == "N") {
  if (lat_dir == "s" | lat_dir == "S") {lat <- -lat}          
} else {writeLines("Direction not correct, Lat will point to North Hemisphere")}
return(lat)
}
# end function lat.calc
#
long.calc <- function() {
#  
long_deg <- as.numeric(readline("Introduce longitude degrees:  "))
long_min <- as.numeric(readline("Introduce longitude minuts:  "))
long_sec <- as.numeric(readline("Introduce longitude seconds:  "))
long_dir <- as.character(readline("Introduce longitude direction: ")) 
# calculating long_degree:
writeLines("Calculating Longitude in degrees...")
if (long_deg > -180 & long_deg < 180) {
  if (long_min >= 0 & long_min <= 60) {minuts <- long_min/60.} else {minuts <- 0.0}
  if (long_sec >= 0 & long_sec <= 60) {seconds <- long_sec/3600.} else {seconds <- 0.0}
} else if (long_deg > 180 & long_deg <= 360) {
  writeLines("Degrees btw 0 and 360 degrees. Recalculating longitude...")
  long_deg <- 360 - long_deg 
  long_dir <- "W"
  if (long_min >= 0 & long_min <= 60) {minuts <- long_min/60.} else {minuts <- 0.0}
  if (long_sec >= 0 & long_sec <= 60) {seconds <- long_sec/3600.} else {seconds <- 0.0}
} else { 
  if (long_deg < -180 | long_deg > 360) {
    writeLines("Degrees not correct!!")
    stop()}
} 
long <- long_deg + minuts + seconds
if (long_dir == "e" | long_dir == "E" | long_dir == "w" | long_dir == "W") {
  if (long_dir == "w" | long_dir == "W") {long <- -long}
} else {writeLines("Direction not correct, Longitude will point to East coordenates")}
return(long)
}
# end function long.calc  
read.file <- function(){
  if (fileFmt == "SEF") {
    #  fileHead <- TRUE
    #  fileRead <- file.choose()
    if (fileHead != TRUE) {
      writeLines("Header is defined as not exist.")
      writeLines("SEF is a format with header in first line, this function may not work properly.")
      cat("Header is defined as not exist.",file = "log.txt", append = TRUE, fill = TRUE)
      cat("SEF is a format with header in first line, this function may not work properly",file = "log.txt", append = TRUE, fill = TRUE)}
    fileHead <- TRUE
    data_val <- read.delim(fileRead, header = fileHead, stringsAsFactors = FALSE, sep = "\t", quote = "", skip = 12)
    #  print(data_meta)  
    assign("data_val", data_val, envir = globalenv())
  } else if (fileFmt == "ERACLIM") {
    #  fileRead <- file.choose()
    if (fileHead != TRUE) {
      writeLines("Header is defined as not exist.")
      writeLines("ERACLIM is a format with header in first line, so this function may not work proprely!!")
      cat("Header is defined as not exist.",file = "log.txt", append = TRUE, fill = TRUE)
      cat("ERACLIM is a format with header in first line, so this function may not work properly!!",file = "log.txt", append = TRUE, fill = TRUE)}
    data_val <- read.table(fileRead, header = fileHead, stringsAsFactors = FALSE, sep ="", quote = "", na.strings = "data_error") 
    assign("data_val", data_val, envir = globalenv())
  } else {
    file_ext <- substr(fileRead, start= nchar(fileRead)-2, stop = nchar(fileRead))
    #print(file_ext)
    if (file_ext == "csv") {
      data_val <- read.csv(fileRead, header = fileHead, stringsAsFactors = FALSE, na.strings = "data_error")
      data_val1 <- read.csv2(fileRead, header = fileHead, dec = "." ,stringsAsFactors = FALSE, na.strings = "data_error")
      #  print(data_val)
      #  print(data_val1)
      #  data_len <- length(data_val)
      #  data1_len <- length(data_val1)
      if (ncol(data_val) < ncol(data_val1)) {data_val <- data_val1} 
    } else {data_val <- read.delim(fileRead, header = fileHead, stringsAsFactors = FALSE, sep = "", na.strings = "data_error")}
    assign("data_val", data_val, envir = globalenv())
    #print(data_val) 
  }
  # In case of mean/sum file exist
  if (meanchk) {
    writeLines("----> mean/sum file <----")
    fileRead1 <- file.choose()
    file_ext1 <- substr(fileRead1, start= nchar(fileRead1)-2, stop = nchar(fileRead1))
    if (file_ext1 == "csv") {
      data_sum <- read.csv(fileRead1, header = fileHead, stringsAsFactors = FALSE, na.strings = "data_error")
      data_sum1 <- read.csv2(fileRead1, header = fileHead, dec = "." ,stringsAsFactors = FALSE, na.strings = "data_error")
      if (ncol(data_sum) < ncol(data_sum1)) {data_sum <- data_sum1} 
    } else {data_sum <- read.delim(fileRead1, header = fileHead, stringsAsFactors = FALSE, sep = "", na.strings = "data_error")}
    assign("data_sum", data_sum, envir = globalenv()) 
  }
}