INSERT INTO censo_domicilio02_piabanha
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
  c.v131, c.v132
  FROM set_cens_piabanha AS sp INNER JOIN censo_domicilio02 AS c ON sp.cod_setor = c.cod_setor