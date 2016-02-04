CREATE OR REPLACE FUNCTION get_package_dependencies(src integer, allDeps integer[] = '{}', self integer = NULL) RETURNS integer[] AS $$
DECLARE
    deps integer[] := '{}';
    pkg integer;
BEGIN
	IF self IS NULL THEN
		self = src;
	END IF;
	--ARRAY_APPEND(deps, 30)
	--FOR i IN 1..src LOOP
	--	deps := array_append(deps, i);
	--END LOOP;
	--SELECT array_agg(i) INTO deps FROM generate_series(1, src) AS i;
	SELECT array_agg(package) INTO deps FROM (
		SELECT package FROM package_dependencies WHERE source_package = src
	) AS dep;

	-- Go through deps
	-- Is it in allDeps?
	-- If not, add to alldeps and run the function!
	IF deps IS NOT NULL THEN
		FOREACH pkg IN ARRAY deps LOOP
			IF (pkg = self) or (SELECT pkg = ANY(allDeps)) THEN
				-- That's fine, ignore this.
				RAISE NOTICE 'reading dep % twice', pkg;
			ELSE
				RAISE NOTICE 'trying to add %', pkg;
				allDeps = array_append(allDeps, pkg);
				allDeps = get_package_dependencies(pkg, allDeps, self);
			END IF;
		END LOOP;
	END IF;		
	
	RETURN allDeps;
END;
$$ LANGUAGE plpgsql STABLE;

--SELECT get_package_dependencies(1),get_package_dependencies(2),get_package_dependencies(3),get_package_dependencies(4)  as result 
SELECT get_package_dependencies(1)  as result 
-- 50 000