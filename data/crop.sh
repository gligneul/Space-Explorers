ni=8
nj=8
dim=256
img="asteroid"

for i in $(seq $ni); do
    for j in $(seq $nj); do
        x=$(( ($i - 1) * $dim ))
        y=$(( ($j - 1) * $dim ))
        id=$(( ($j - 1) * $ni + $i))
        convert "$img".png -crop "$dim"x"$dim"+"$x"+"$y" "$img"_"$id".png
    done
done
    
