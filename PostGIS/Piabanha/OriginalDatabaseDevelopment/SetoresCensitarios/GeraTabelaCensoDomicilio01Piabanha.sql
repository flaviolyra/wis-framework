﻿INSERT INTO censo_domicilio01_piabanha
SELECT sp.gid_set_agr, c.cod_setor, c.situacao_setor,
  c.v001, c.v002, c.v003, c.v004, c.v005, c.v006, c.v007, c.v008, c.v009, c.v010,
  c.v011, c.v012, c.v013, c.v014, c.v015, c.v016, c.v017, c.v018, c.v019, c.v020,
  c.v021, c.v022, c.v023, c.v024, c.v025, c.v026, c.v027, c.v028, c.v029, c.v030,
  c.v031, c.v032, c.v033, c.v034, c.v035, c.v036, c.v037, c.v038, c.v039, c.v040,
  c.v041, c.v042, c.v043, c.v044, c.v045, c.v046, c.v047, c.v048, c.v049, c.v050,
  c.v051, c.v052, c.v053, c.v054, c.v055, c.v056, c.v057, c.v058, c.v059, c.v060,
  c.v061, c.v062, c.v063, c.v064, c.v065, c.v066, c.v067, c.v068, c.v069, c.v070,
  c.v071, c.v072, c.v073, c.v074, c.v075, c.v076, c.v077, c.v078, c.v079, c.v080,
  c.v081, c.v082, c.v083, c.v084, c.v085, c.v086, c.v087, c.v088, c.v089, c.v090,
  c.v091, c.v092, c.v093, c.v094, c.v095, c.v096, c.v097, c.v098, c.v099, c.v100,
  c.v101, c.v102, c.v103, c.v104, c.v105, c.v106, c.v107, c.v108, c.v109, c.v110,
  c.v111, c.v112, c.v113, c.v114, c.v115, c.v116, c.v117, c.v118, c.v119, c.v120,
  c.v121, c.v122, c.v123, c.v124, c.v125, c.v126, c.v127, c.v128, c.v129, c.v130,
  c.v131, c.v132, c.v133, c.v134, c.v135, c.v136, c.v137, c.v138, c.v139, c.v140,
  c.v141, c.v142, c.v143, c.v144, c.v145, c.v146, c.v147, c.v148, c.v149, c.v150,
  c.v151, c.v152, c.v153, c.v154, c.v155, c.v156, c.v157, c.v158, c.v159, c.v160,
  c.v161, c.v162, c.v163, c.v164, c.v165, c.v166, c.v167, c.v168, c.v169, c.v170,
  c.v171, c.v172, c.v173, c.v174, c.v175, c.v176, c.v177, c.v178, c.v179, c.v180,
  c.v181, c.v182, c.v183, c.v184, c.v185, c.v186, c.v187, c.v188, c.v189, c.v190,
  c.v191, c.v192, c.v193, c.v194, c.v195, c.v196, c.v197, c.v198, c.v199, c.v200,
  c.v201, c.v202, c.v203, c.v204, c.v205, c.v206, c.v207, c.v208, c.v209, c.v210,
  c.v211, c.v212, c.v213, c.v214, c.v215, c.v216, c.v217, c.v218, c.v219, c.v220,
  c.v221, c.v222, c.v223, c.v224, c.v225, c.v226, c.v227, c.v228, c.v229, c.v230,
  c.v231, c.v232, c.v233, c.v234, c.v235, c.v236, c.v237, c.v238, c.v239, c.v240,
  c.v241
  FROM set_cens_piabanha AS sp INNER JOIN censo_domicilio01 AS c ON sp.cod_setor = c.cod_setor