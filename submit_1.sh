#!/bin/bash
source ~/Programs/amber22/amber22/amber.sh
export CUDA_VISIBLE_DEVICES=1
# for min1, min2, and md1, use pmemd.cuda_DPFP first, because there will be less errors than pmemd.cuda and pmemd.MPI if there is huge energy jump.
#mpirun  -np 12 $AMBERHOME/bin/pmemd.MPI -O -i ../inputs/8AA_min1.in -o hybrid_min1.out -p ../inputs/hybrid.prmtop -c ../inputs/hybrid.inpcrd -r hybrid_min1.ncrst -ref ../inputs/hybrid.inpcrd
#mpirun  -np 12 $AMBERHOME/bin/pmemd.MPI -O -i ../inputs/8AA_min2.in -o hybrid_min2.out -p ../inputs/hybrid.prmtop -c hybrid_min1.ncrst -r hybrid_min2.ncrst

$AMBERHOME/bin/pmemd.cuda_DPFP -O -i ../../in/8AA_min1.in -o hybrid_min1.out -p ../inputs/hybrid_sh.prmtop -c ../inputs/hybrid_sh.inpcrd -r hybrid_min1.ncrst -ref ../inputs/hybrid_sh.inpcrd
$AMBERHOME/bin/pmemd.cuda_DPFP -O -i ../../in/8AA_min2.in -o hybrid_min2.out -p ../inputs/hybrid_sh.prmtop -c hybrid_min1.ncrst -r hybrid_min2.ncrst

$AMBERHOME/bin/pmemd.cuda_DPFP -O -i ../../in/MD/8AA_md1.in -o hybrid_md1.out -p ../inputs/hybrid_sh.prmtop -c hybrid_min2.ncrst -r hybrid_md1.ncrst -x hybrid_md1.nc -ref hybrid_min2.ncrst

for ((i=2; i<3; i++))
do
#	j=$((i-1))
#	$AMBERHOME/bin/pmemd.cuda -O -i ../../in/MD/8AA_md2.in -o hybrid_md${i}.out -p ../inputs/hybrid_sh.prmtop -c hybrid_md${j}.ncrst -r hybrid_md${i}.ncrst -x hybrid_md${i}.nc

# use hybrid_md2.ncrst, in case the previous run failed.
	$AMBERHOME/bin/pmemd.cuda -O -i ../../in/MD/8AA_md2.in -o hybrid_md${i}.out -p ../inputs/hybrid_sh.prmtop -c hybrid_md1.ncrst -r hybrid_md${i}.ncrst -x hybrid_md${i}.nc
done
exit;
#$AMBERHOME/bin/pmemd.cuda -O -i 8AA_md2.in -o AA_di_md3.out -p AA_di.prmtop -c AA_di_md2.ncrst -r AA_di_md3.ncrst -x AA_di_md3.nc
