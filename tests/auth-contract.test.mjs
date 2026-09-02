import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
const root=new URL('..',import.meta.url).pathname;

test('auth providers return through a server callback that exchanges the PKCE code',()=>{
  const login=readFileSync(join(root,'components/login-form.tsx'),'utf8');
  const callback=readFileSync(join(root,'app/auth/callback/route.ts'),'utf8');
  assert.match(login,/auth\/callback\?next=\/home/);
  assert.match(callback,/exchangeCodeForSession\(code\)/);
  assert.match(callback,/requestedNext\.startsWith\('\/'\)/);
});
