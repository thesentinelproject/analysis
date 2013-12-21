
 myRscript=../../../code/R/test_queryThreatWiki.R
  code_dir=../../../code/R
output_dir=../output
   tmp_dir=${output_dir}/tmp

##################################################
if [ ! -d ${output_dir} ]; then
	mkdir ${output_dir}
fi

if [ ! -d ${tmp_dir} ]; then
	mkdir ${tmp_dir}
fi

stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${output_dir} ${code_dir} ${tmp_dir} < ${myRscript} 2>&1 > ${stdoutFile}

