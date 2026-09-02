import { AppShell } from '@/components/app-shell';
import { getCurrentProfile } from '@/lib/repositories/catalog';
export default async function ProductLayout({children}:{children:React.ReactNode}){const profile=await getCurrentProfile();return <AppShell profile={profile}>{children}</AppShell>}
