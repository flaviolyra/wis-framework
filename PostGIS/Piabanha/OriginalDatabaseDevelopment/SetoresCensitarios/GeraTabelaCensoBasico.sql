﻿COPY censo_basico (cod_setor, cod_grande_regiao, nome_grande_regiao, cod_uf, nome_uf, cod_meso, nome_meso, cod_micro, nome_micro, cod_rm, nome_rm,
  cod_municipio, nome_municipio, cod_distrito, nome_distrito, cod_subdistrito, nome_subdistrito, cod_bairro, nome_bairro, situacao_setor, v001, v002, v003,
  v004, v005, v006, v007, v008, v009, v010, v011, v012) FROM 'c:\censo2010\BaseInfSet2010_RJ\excel\basico_rj_1.txt' ENCODING 'WIN1252' NULL ''