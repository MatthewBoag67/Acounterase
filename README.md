# Acounterase
Acountertase (A'counter'ase) is an ImageJ (FIJI) Macro that quantifies the protein aggregates amongst a 3-dimensional Z-stack. The model was designed to analyze a-synuclein aggregates (distinguishing oligomeric species from cytosolic punctate) and intracellular ferritin encapsulated within engorged autophagosomes. However, this macro is not linear in detection, meaning an array of inputs can be accurately quantified in a completely automated manner. 

Instructions
  Image recognition is dependant upon ".nd2" file formats
  Input sources can be named "a.nd2", "b.nd2", "c.nd2", "d.nd2", "e.nd2", & "f.nd2" (non ".nd2" file can be converted by simply adding the suffix, this is to no detriment of the         image)
  To indicate the save file directory, place each file that you want to analyse into their own respective folder.
  Open the images in grayscale and do NOT split channels
  After placing files into their individual folders, open them in IMageJ (FIJI).
  Install the macro by method of choice (e.g., Plugin >> Macro >> Install, or via applications folder)
  Even if two files are open with the same name, the macro uses metadata to determine the save file location. This means that same name files will be saved to their respective     input location.
  Run the macro until automatically ended. There should now be the binary output files as well as the .txt file containing all the quantitative data in you inputs folder.
