# Automated data collection for Image Cytometry

The procedure has been created for Ti2E inverted microscopes. Below you find the sketch of the JOB created in the NIS software. The description of the different steps should work as a model to recreate the instructions for the automated image collection by  motorized microscopes from different brands.

## Rationale

The procedure starts with the collection of a _Map_, a low resoluion image (4x or 10x magnification) of the sample to be acquired. The map ia obtained from the stitching of images to cover an extended area - millimiters or centimeters - and is employed to define regions to collect, at high resolution, the required number of events. The frequency of the targeted phenotype is obviously the starting point to fix the final number of regions. After the definition of the regions of interest, the system switches to the desired magnification for the high resolution acquisition.

Sometimes this step could also be an intermediate passage to retrieve the final targets. As explained in _Furia et al., Front. Onc. 2022, Image Cytometry analysis of a __Tissue Micro-Array (TMA)__ starts from the _Map_ of the TMA, to localize all the cores, and then moving to an intermediate resolution and sensitivity acquisition of every core, with a 20x objective. Then, extracting from the image metadata the stage coordinates of the selected cores, the final acquisition starts employing a high resolution 60x oil-immersion objective. 

Region of interest have predefined dimension in order to build a _Local Focus Surface_ thus optimizing the maintenance of the focal plane for all the collected images. Finally, the automated acquisition collect the data for all the channels initially defined by the user.

## To be continued...

