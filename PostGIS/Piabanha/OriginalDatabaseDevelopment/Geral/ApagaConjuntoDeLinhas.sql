﻿DELETE FROM hidrografia WHERE gid IN (SELECT unnest(ARRAY[4165, 4166]))