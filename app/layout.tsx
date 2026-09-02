import type { Metadata, Viewport } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: { default:'Sea N Shore Global Shipping Community', template:'%s · Sea N Shore' },
  description:'The professional network, careers, learning and maritime community platform for seafarers and shore professionals.',
  applicationName:'Sea N Shore',
  keywords:['maritime','shipping','seafarers','merchant navy','maritime jobs','SIRE 2.0','shipping community'],
  openGraph:{title:'Sea N Shore Global Shipping Community',description:'Where maritime professionals build careers, connections and knowledge.',type:'website'}
};
export const viewport: Viewport = { width:'device-width', initialScale:1, themeColor:'#08233d' };
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="en"><body>{children}</body></html>}
