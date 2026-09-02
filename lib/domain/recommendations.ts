import type { Job, Profile } from '@/lib/data/seed';
export function recommendedRoles(profile: Profile): string[] {
  const text = `${profile.role} ${profile.vesselTypes.join(' ')} ${profile.skills.join(' ')}`.toLowerCase();
  const roles = new Set<string>();
  if (text.includes('master') || text.includes('chief officer')) { roles.add('Marine Superintendent'); roles.add('Vetting Inspector'); roles.add('Marine Assurance Manager'); }
  if (text.includes('chief engineer') || text.includes('pms')) { roles.add('Technical Superintendent'); roles.add('Fleet Performance Manager'); }
  if (text.includes('sire')) roles.add('Vetting / SIRE Specialist');
  roles.add('Maritime Trainer');
  return [...roles].slice(0,5);
}
export function filterJobs(jobs: Job[], query:string, vesselType:string) {
  const q=query.trim().toLowerCase();
  return jobs.filter(job => (!q || `${job.title} ${job.company} ${job.rank} ${job.skills.join(' ')}`.toLowerCase().includes(q)) && (vesselType==='All' || job.vesselType===vesselType));
}
