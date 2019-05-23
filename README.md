# QC
Quality Control tests for meteorologic datasets recovered.

qc.test information:

This function test daily sunshine values to max daily value that could take and optionally test with mean or sum according to case applied.
In some publications papers, after a certain date and in some places, sunshine hours start to be designated by "insolation".
Diference between both is in units, ie. sunshine hours its in hour.minuts units and insolation in hours units.
So sunshine hours = insolation. Based on "C3S-DRS guideline" variable take name of sunshine hours(ss) and units = hours(h), meaning that all values that are in hour.minuts will be convert to only hours, making a metadata observation of original values.
