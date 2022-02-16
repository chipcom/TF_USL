rem _mo21usl
create_dict -in=d:\_mo\tf_usl\in -out=d:\_mo\tf_usl\out 2>log.txt
copy d:\_mo\tf_usl\1\_mo2unit.dbf .\out
copy d:\_mo\tf_usl\vmp\_mo2vmp_usl.dbf .\out
copy d:\_mo\tf_usl\vmp\_mo2vmp_usl.dbt .\out
copy d:\_mo\tf_usl\src_t005\_mo_t005.dbf .\out
copy d:\_mo\tf_usl\src_t005\_mo_t005.dbt .\out
copy .\out\*.* d:\_mo\_arc\
rem copy *.dbt d:\_mo\_arc\
del d:\_mo\_arc\v001.dbf
rem copy *.txt d:\_mo\_arc\
rem copy *.ttt d:\_mo\_arc\
copy .\out\*.* d:\_mo\chip\EXE
rem copy *.dbf d:\_mo\chip\EXE\
rem copy *.dbt d:\_mo\chip\EXE\
rem copy d:\_mo\tf_usl\1\_mo2unit.dbf d:\_mo\chip\EXE\
del d:\_mo\chip\EXE\v001.dbf
rem copy *.txt d:\_mo\chip\EXE\
rem copy *.ttt d:\_mo\chip\EXE\
