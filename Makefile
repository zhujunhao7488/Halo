CXX = g++
CFLAGS = -std=c++17 -O3 -march=native -L./ -I./Halo

CCEH_F := $(CFLAGS) -DCCEHT -std=c++17 -O3 -march=native \
	-L./third/pmdk/src/nondebug \
	-I./third/pmdk/src/include  -Wl,-rpath,./third/pmdk/src/nondebug

DASH_F := $(CFLAGS) -DDASHT -std=c++17 -O3 -march=native \
	-L./third/pmdk/src/nondebug \
	-I./third/pmdk/src/include  -Wl,-rpath,./third/pmdk/src/nondebug

CLEVEL_F := $(CFLAGS) -DCLEVELT -std=c++17 -O3 -march=native \
	-I./third/CLevel/src/common -I./third/CLevel -I./third/CLevel/src -I./third/CLevel/src/common



PCM := -I./pcm -L./pcm

CFLAGS_PMDK := -std=c++17 -O3 -I./ -L./

tar = HALO CCEH DASH CLEVEL PCLHT VIPER SOFT CLHT

all: $(tar)

$(tar): LIBPCM

LIBPCM:
	make -C pcm

libHalo.a: Halo/Halo.cpp Halo/Halo.hpp Halo/Pair_t.h
	$(CXX) $(CFLAGS) -c -o libHalo.o $<
	ar rv libHalo.a libHalo.o

libSOFT.a: third/SOFT/ssmem.cpp  third/SOFT/*
	$(CXX) $(CFLAGS) -c -o libSOFT.o $<
	ar rv libSOFT.a libSOFT.o

libPCLHT.a: third/PCLHT/clht_lb_res.cpp
	$(CXX) $(CFLAGS) -c -o libPCLHT.o $< -lvmem
	ar rv libPCLHT.a libPCLHT.o

libCLHT.a: third/CLHT/src/clht_lb_res.c
	$(CXX) $(CFLAGS) -c -o libCLHT.o $^
	ar rv libCLHT.a libCLHT.o 


HALO: ycsb.cpp libHalo.a hash_api.h
	$(CXX) -DHALOT $(CFLAGS) $(PCM) -o $@ $< -lHalo -lpthread -mavx -lPCM -lpmem

PCLHT: ycsb.cpp libPCLHT.a hash_api.h
	$(CXX) -DPCLHTT $(CFLAGS) $(PCM) -o $@ $< -lPCLHT -lpthread -lvmem -lPCM 

CLHT: ycsb.cpp libCLHT.a hash_api.h
	$(CXX) -DCLHTT $(CFLAGS) $(PCM) -o $@ $< -lCLHT -lpthread -lPCM 

SOFT: ycsb.cpp libSOFT.a hash_api.h
	$(CXX) -DSOFTT $(CFLAGS) $(PCM) -o $@ $< -lSOFT -lpthread -lvmem -lPCM 

VIPER: ycsb.cpp hash_api.h third/viper/*
	$(CXX) -DVIPERT $(CFLAGS) $(PCM) -o $@ $< -lpthread -lpmem -lPCM 

CLEVEL: ycsb.cpp libHalo.a hash_api.h
	$(CXX) $(CLEVEL_F) $(CFLAGS) $(PCM) -o $@ $< -lpthread -lpmemobj -lPCM 

CUSTOM_PMDK:
	chmod +x ./third/pmdk/utils/check-os.sh 
	make -C ./third/pmdk/src

CCEH: ycsb.cpp hash_api.h CUSTOM_PMDK
	$(CXX) $(CCEH_F) $(PCM) -o $@ $< -lpthread -lPCM -lpmemobj

DASH: ycsb.cpp hash_api.h CUSTOM_PMDK
	$(CXX) $(DASH_F) $(PCM) -o $@ $< -lpthread -lpmemobj -lPCM 




ycsb_PMDK: Halo_PMDK/Halo.cpp  Halo_PMDK/*
	$(CXX) $(CFLAGS_PMDK) -c -o libHalo_PMDK.o $< 
	$(CXX) $(CFLAGS_PMDK) -c -o libCLHT_PMDK.o Halo_PMDK/clht_lb_res.cpp
	$(CXX) $(CFLAGS_PMDK) $(PCM) libHalo_PMDK.o libCLHT_PMDK.o ycsb.cpp -o ycsb_PMDK -lpthread -mavx -lPCM -lpmemobj
clean:
	rm -f *.o *.a $(tar)
cleanAll:
	rm -f *.o *.a $(tar)
	make -C pcm clean
	make -C ./third/pmdk/src clean