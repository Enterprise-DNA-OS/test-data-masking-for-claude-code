import {getDb,REPO_ROOT} from './lib/db.mjs';
import {migrate} from './migrate.mjs';
import {seed} from './seed.mjs';
import {run,table} from './masking.mjs';
import path from 'node:path';
const db=await getDb();try{await migrate(db);await seed(db);for(const name of ['Partner acceptance','Partner training'])await run(db,['import','datamasker','--environment='+name,'--dir='+path.join(REPO_ROOT,'fixtures/salesforce'),'--actor=Demo operator']);console.log(table(await run(db,['readiness'])));}finally{await db.close();}
