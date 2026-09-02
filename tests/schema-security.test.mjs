import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
const root=new URL('..',import.meta.url).pathname;
const schemaPath=process.env.SNS_SCHEMA || join(root,'supabase/schema.sql');
const sql=readFileSync(schemaPath,'utf8');

test('every public table has row-level security enabled',()=>{
  const tables=[...sql.matchAll(/create table if not exists public\.([a-z_]+)/gi)].map(m=>m[1]);
  const rls=new Set([...sql.matchAll(/alter table public\.([a-z_]+) enable row level security/gi)].map(m=>m[1]));
  const missing=tables.filter(t=>!rls.has(t));
  assert.deepEqual(missing,[]);
});

test('security definer helpers are not exposed in public schema',()=>{
  const blocks=[...sql.matchAll(/create or replace function\s+([\w.]+)\([^]*?\$\$;/gi)];
  const exposed=blocks.filter(m=>/security definer/i.test(m[0])&&m[1].startsWith('public.')).map(m=>m[1]);
  assert.deepEqual(exposed,[]);
  assert.match(sql,/function private\.is_admin\(\)/i);
  assert.match(sql,/revoke all on function private\.is_admin\(\) from public/i);
});
