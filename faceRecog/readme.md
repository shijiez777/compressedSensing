1. run normalizeANdSave script to process the image data
    1.  filter out useless photos
    2. Normalize images by dividing images by 255.
2. Store the image data in a container.Map.
    - key: class name
    - value: a 64 * (ingH*igmW) matrix containing all 64 images belonging to that class, flattened and stacked together
3. save the data to data.mat.