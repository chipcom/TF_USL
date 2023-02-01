create_dict -in=d:\_mo\tf_usl\in -out=d:\_mo\tf_usl\out 2>log.txt
copy d:\_mo\tf_usl\1\_mo3unit.dbf .\out
copy d:\_mo\tf_usl\vmp\_mo3vmp_usl.dbf .\out
copy d:\_mo\tf_usl\vmp\_mo3vmp_usl.dbt .\out
copy d:\_mo\tf_usl\src_t005\_mo_t005.dbf .\out
copy d:\_mo\tf_usl\src_t005\_mo_t005.dbt .\out
copy d:\_mo\tf_usl\OKATO\*.dbf .\out
copy .\out\*.* d:\_mo\_arc\
copy .\out\*.* d:\_mo\chip\EXE
rem del d:\_mo\_arc\v001.dbf
rem del d:\_mo\chip\EXE\v001.dbf
