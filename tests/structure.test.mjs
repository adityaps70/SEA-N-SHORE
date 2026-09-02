import test from 'node:test';
import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

const root = new URL('..', import.meta.url).pathname;
const required = [
  'package.json','app/layout.tsx','app/page.tsx','app/loading.tsx','app/error.tsx','app/not-found.tsx','app/manifest.ts','app/(network)/home/page.tsx',
  'app/(careers)/jobs/page.tsx','app/(careers)/recruiter/page.tsx','app/(network)/community/page.tsx','app/(learning)/learn/page.tsx',
  'app/(growth)/mentorship/page.tsx','app/(growth)/wellness/page.tsx','app/(growth)/branding/page.tsx',
  'app/(knowledge)/events/page.tsx','app/(knowledge)/knowledge/page.tsx','app/(network)/assistant/page.tsx',
  'app/(network)/profile/page.tsx','app/(network)/verification/page.tsx','app/(admin)/admin/page.tsx','lib/supabase/client.ts','lib/supabase/server.ts',
  'proxy.ts','app/auth/callback/route.ts','lib/data/seed.ts','components/app-shell.tsx','components/feed.tsx','components/ai-assistant.tsx'
];

test('production app contains all required startup modules', () => {
  for (const file of required) assert.equal(existsSync(join(root, file)), true, `missing ${file}`);
});

test('package pins production stack', () => {
  const pkg = JSON.parse(readFileSync(join(root, 'package.json'), 'utf8'));
  assert.match(pkg.dependencies.next, /^16\.3\./);
  assert.match(pkg.dependencies.react, /^19\.2\./);
  assert.ok(pkg.dependencies['@supabase/ssr']);
  assert.ok(pkg.dependencies['@supabase/supabase-js']);
  assert.ok(pkg.devDependencies.tailwindcss);
});

test('navigation exposes main maritime product surfaces', () => {
  const shell = readFileSync(join(root, 'components/app-shell.tsx'), 'utf8');
  for (const label of ['Home','Jobs','Community','Learn','Events','Profile','Mentorship','Wellness','Career Branding','Knowledge Hub','AI Maritime Assistant']) {
    assert.ok(shell.includes(label), `navigation missing ${label}`);
  }
});
