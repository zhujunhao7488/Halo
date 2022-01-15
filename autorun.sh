# export LD_LIBRARY_PATH=/usr/local/lib64/vmem_debug:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/aim/hdk/Halo/third/pmdk/src/nondebug:$LD_LIBRARY_PATH
for w in ycsbd
#  ycsbb ycsbc ycsbd ycsbe ycsbf ycsbg ycsbh ycsbj ycsbak ycsbal ycsbam PiBench1 PiBench2 PiBench3 PiBench4 PiBench5 PiBench6 PiBench7 PiBench8
do
    for t in 32
    do  
        for h in HALO
        do
            # make
            numactl -N 0 ./$h $w $t
            rm /mnt/pmem/* -rf
            echo "------------------------------------------------\n"
        done
    done
done

# update: HALO CLEVEL VIPER