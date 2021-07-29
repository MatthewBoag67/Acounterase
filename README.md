# Acountertase
Acountertase (A'counter'ase) is an ImageJ (FIJI) Macro that quantifies the protein aggregates amongst a 3-dimensional Z-stack. The model was designed to analyze a-synuclein aggregates (distinguishing oligomeric species from cytosolic punctate) and intracellular ferritin encapsulated. However, this macro is not linear in detection, meaning an array of inputs can be accurately quantified in a completely automated manner. 

Instructions
  1. Open all images under the Bio-formats program of ImageJ
  2. Have the images placed into a location where you would like you outputfiles saved
  3. Install the macro by method of choice (e.g., Plugin >> Macro >> Install, or via applications folder)
  4. Run the macro until automatically ended
  
  NOTE: Even if two files are open with the same name, the macro uses metadata to determine the save file location. 
        This means that same name files will be saved to their respective input location.
